//
//  FahrtTableViewController.swift
//  easyRiderStoryboard
//
//  Created by Sean Gaenicke on 02.04.20.
//  Copyright © 2020 Sean Gaenicke. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var distances = [0, 0, 0]


class FahrtTableViewController: UITableViewController, CLLocationManagerDelegate {

    var sortedArr = [String]()
    let locationManager = CLLocationManager()
    var currentCoordinate = CLLocationCoordinate2D()
    
    
   var fahrten = ["Street 1","Street 2","Street 3"]
    
    func namen(index: Int) -> String {
        let name = "Fahrt " + String(index)
        return name
    }
    
  
    func getLocation(adr: [String]){
        
        guard let location_ = locationManager.location?.coordinate else {
            print("no user location")
            return
        }

        struct Streets {
            let adresse: String
            let distance: Int
            let eta: Int
        }
        
        var results = [Streets]()
        
        let group = DispatchGroup()

        for i in 0...adr.count-1 {
            group.enter()
            
            let localSearchRequest = MKLocalSearch.Request()
            localSearchRequest.naturalLanguageQuery = String(adr[i])
            let region = MKCoordinateRegion(center: self.currentCoordinate, latitudinalMeters: 0.2, longitudinalMeters: 0.2)
            localSearchRequest.region = region
            let localSearch = MKLocalSearch(request: localSearchRequest)
            localSearch.start(completionHandler: {(response, _) in
                
                guard let response = response else { return }
                guard let firstMapItem = response.mapItems.first else { return }
                
                let request = MKDirections.Request()
                
                request.source = firstMapItem
                request.destination = MKMapItem.forCurrentLocation()
                request.transportType = .walking
                request.requestsAlternateRoutes = false
                let directions = MKDirections(request: request)
                
                directions.calculateETA(completionHandler: { (response, error) in
                    
                    guard let response = response else { return }
                    
                    results.append(Streets(adresse: self.fahrten[i], distance: Int(response.distance), eta: Int(response.expectedTravelTime)))
                    
                })
                
                
            })
            }
    }



    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        guard let currentLocation = locations.first else { return }
        currentCoordinate = currentLocation.coordinate
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        var indexArr = [Int]()
        
        getLocation(adr: fahrten)
        
    
        self.locationManager.requestAlwaysAuthorization()

        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fahrten.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "fahrtCell"
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FahrtTableViewCell
        
        cell.fahrt_name.text = namen(index: indexPath.row+1)
        cell.fahrt_adresse.text = fahrten[indexPath.row]
        cell.fahrt_distanz.text = "Lädt..."
        
            return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 84
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
