//
//  ProfileViewController.swift
//  sharey.id
//
//  Created by Sean Gaenicke on 01.05.20.
//  Copyright © 2020 Sean Gaenicke. All rights reserved.
//

import UIKit

var finishedReq = 0

let notification = UINotificationFeedbackGenerator()
let impact = UIImpactFeedbackGenerator()
let selection = UISelectionFeedbackGenerator()


class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    
    @IBOutlet weak var topTVC: UITableView!
    @IBOutlet weak var middleTVC: UITableView!
    @IBOutlet weak var bottomTVC: UITableView!
    
    
    
    
    struct Response: Codable { // or Decodable
        let username: String
        let name: String
        let birthdate: String
        let city: String
        let country: String
        let image_string: String
        let quote: String
        let infotext: String
        let email_confirmed: Bool
        let nonce: String
        let password_hash: String
        let secure_ID: String
        let is_following: [String]
        let accepted_users: [String]
        let requested_users: [String]
        let blocked_users: [String]
        let is_private: Bool
        let is_verified: Bool
        let app_string: String
        let is_company: Bool
        let posts: [String]
        let gifts: [String]
    }
    
    var username = String()
    var name = String()
    var birthdate = String()
    var city = String()
    var country = String()
    var image_string = String()
    var quote = String()
    var infotext = String()
    var email_confirmed = Bool()
    var nonce = String()
    var password_hash = String()
    var secure_ID = String()
    var is_following = [String]()
    var accepted_users = [String]()
    var requested_users = [String]()
    var blocked_users = [String]()
    var is_private = Bool()
    var is_verified = Bool()
    var app_string = String()
    var is_company = Bool()
    var posts = [String]()
    var gifts = [String]()
    
    var userdata = Response(username: String(), name: String(), birthdate: String(), city: String(), country: String(), image_string: String(), quote: String(), infotext: String(), email_confirmed: Bool(), nonce: String(), password_hash: String(), secure_ID: String(), is_following: [String](), accepted_users: [String](), requested_users: [String](), blocked_users: [String](), is_private: Bool(), is_verified: Bool(), app_string: String(), is_company: Bool(), posts: [String](), gifts: [String]())
    
    
    
    var posts_of_user = [String]()
    
    
    struct postsData: Codable {
        let post_id: String
        let question_by: String
        let question_text: String
        let answer_text: String
        let liked_by: [String]
        let repost_by: [String]
        let time_and_date_of_post: String
    }
    
    var post_data = [postsData(post_id: String(), question_by: String(), question_text: String(), answer_text: String(), liked_by: [String](), repost_by: [String](), time_and_date_of_post: String())]
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pub_username_id = "seankmg"
        pub_name_id = "Sean"
        
        print("pub_username_id: \(pub_username_id)")
        print("pub_name_id: \(pub_name_id)")
        
        
        
        topTVC.delegate = self
        topTVC.dataSource = self
        
        middleTVC.delegate = self
        middleTVC.dataSource = self
        
        bottomTVC.delegate = self
        bottomTVC.dataSource = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(do_a_refresh), name: Notification.Name("RefreshTable"), object: nil)
        
        
        
        
    }

    
    @objc func do_a_refresh (notification: NSNotification){ //add stuff
        print("refresh table")
        DispatchQueue.global(qos: .background).async {

            // Background Thread
           //self.getInfo()
            DispatchQueue.main.async {
                // Run UI Updates
                    
                
                if finishedReq == 0 {
                    
                    if (self.post_data[self.userdata.posts.count-1].question_text == "") {
                        print("error -> empty")
                        
                        self.bottomTVC.reloadData()
                        
                    } else {
                        self.bottomTVC.reloadData()
                    }
                 } else {
                     
                 }
                
            }
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        getInfo()
    }
    
    
    
    func getInfo(){
        
        
        if let url = URL(string: "https://sharey.id/user_emails/sean.z@gmx.de/userinfo.json") {

            
            TaskManager.shared.dataTask(with: url) { (data, response, error) in
              if let data = data {
                  do {
                     let res = try JSONDecoder().decode(Response.self, from: data)
                     print(res.posts)
                    self.posts_of_user = res.posts
                    
                    self.userdata = res
                    

                    print(self.userdata)
                    
                    finishedReq = self.userdata.posts.count
                    print("total requests to do: \(finishedReq)")
                    
                    
                    self.getPosts()
                  } catch let error {
                     print(error)
                  }
               }
           }
        }

    }
    
    func getPosts(){

            for i in 0...self.posts_of_user.count-1 {
                
                   
                    if let url = URL(string: "https://sharey.id/user_emails/sean.z@gmx.de/posts/"+self.posts_of_user[i]+".json") {
                       TaskManager.shared.dataTask(with: url) { (data, response, error) in
                          if let data = data {
                              do {
                                 let res = try JSONDecoder().decode(postsData.self, from: data)
                                 
                                
                    
                                 self.post_data.insert(res, at: i)
                                 finishedReq -= 1
                                
                                
                                 print("post_data\(i) \(self.post_data[i])")
                                 
                                 
                                
                              } catch let error {
                                 print(error)
                              }
                           }
                       }
                    }          
        }
        
    }
    
    
    
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == topTVC {
        return 1
    } else if tableView == middleTVC {
        return 1
    } else {
        return posts_of_user.count
    }
    
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        
        
        
        
        if tableView == topTVC {
            var cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! topTVCell
            

        } else if tableView == middleTVC {
            cell = tableView.dequeueReusableCell(withIdentifier: "showDataCell", for: indexPath)
            
            
        } else {
           var cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! postsTableViewCell
           
            
            cell.like_post_ = { sender in
               
                impact.impactOccurred()
                print("like -> \(self.post_data[indexPath.row].post_id)")
                
            }
            
            cell.repost_post_ = { sender in
               
                impact.impactOccurred()
                print("repost -> \(self.post_data[indexPath.row].post_id)")
                
            }
            
            cell.more_options_ = { sender in
               
                impact.impactOccurred()
                print("show_more_options -> \(self.post_data[indexPath.row].post_id)")
                
            }
            
            cell.report_post_ = { sender in
               
                impact.impactOccurred()
                print("report -> \(self.post_data[indexPath.row].post_id)")
                
            }
            
            
            // here is the data being loaded into the cell
            
            
            while(finishedReq != 0) {
                
                
                
            }
            cell.question_text.text = self.post_data[indexPath.row].question_text
            
            
            print("")
            print("q_text\(indexPath.row) \(self.post_data[indexPath.row].question_text)")
            print("")
            
                cell.answer_text.text = self.post_data[indexPath.row].answer_text
            print("")
            print("a_text\(indexPath.row) \(self.post_data[indexPath.row].answer_text)")
            print("")
                cell.show_likes_button.setTitle(String(self.post_data[indexPath.row].liked_by.count)+" likes", for: .normal)
                cell.show_reshares_button.setTitle(String(self.post_data[indexPath.row].repost_by.count)+"", for: .normal)
                
                
                cell.question_text.isHidden = false
                cell.answer_text.isHidden = false
                cell.like_button.isEnabled = true
                
                
                if (self.post_data[indexPath.row].liked_by.contains(pub_username_id)){
                    cell.like_button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    cell.like_button.tintColor = UIColor.red
                } else {
                    
                }
                
                
                
                cell.show_likes_button.isEnabled = true
                cell.show_likes_button.isHidden = false
                cell.reshare_button.isEnabled = true
                cell.show_reshares_button.isEnabled = true
                cell.show_reshares_button.isHidden = false
                cell.more_options_button.isEnabled = true
                cell.report_post_button.isEnabled = true
                cell.animating.isHidden = true
            }
            
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == topTVC {
            return 150
        } else if tableView == middleTVC {
            return 32
        } else {
            return 158
        }
    }

}
