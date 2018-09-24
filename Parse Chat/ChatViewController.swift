//
//  ChatViewController.swift
//  Parse Chat
//
//  Created by Jangey Lu on 9/23/18.
//  Copyright © 2018 Jangey Lu. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var chatMessageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    var messages: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        // Auto size row height based on cell autolayout constraints
        tableView.rowHeight = UITableView.automaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 50
        // refresh each second
        tableView.dataSource = self
        tableView.delegate = self
        
        queryMessage()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func tapSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
         chatMessage["text"] = chatMessageField.text ?? ""
         chatMessage.saveInBackground { (success, error) in
         if success {
            print("The message was saved!")
            self.chatMessageField.text = ""
         } else if let error = error {
         print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func tapLogout(_ sender: Any) {
        // set user is logout
        PFUser.logOut()
        print("Loged out Success!")
        
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        let message = messages[indexPath.row]
        let messageLabel = message["text"] as! String
        cell.messageLabel.text = messageLabel
        
        if let user = message["user"] as? PFUser {
            // User found! update username label with username
            cell.usernameLabel.text = user.username
        } else {
            // No user found, set default username
            cell.usernameLabel.text = "🤖"
        }
        
        return cell
    }
    
    @objc func onTimer() {
        // Add code to be run periodically
        queryMessage()
    }
    
    func queryMessage(){
        // Associating Users with Messages
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                for message in posts{
                    print(message["text"])
                }
                self.messages = posts
                self.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}
