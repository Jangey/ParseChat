//
//  ChatViewController.swift
//  Parse Chat
//
//  Created by Jangey Lu on 9/23/18.
//  Copyright © 2018 Jangey Lu. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var chatMessageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let chatMessage = PFObject(className: "Message")
    var messages: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // refresh each second
        onTimer()
    }
    
    @IBAction func tapSend(_ sender: Any) {
        
         chatMessage["text"] = chatMessageField.text ?? ""
         chatMessage.saveInBackground { (success, error) in
         if success {
         print("The message was saved!")
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        //cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    @objc func onTimer() {
        // Add code to be run periodically
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        queryMessage()
    }
    
    func queryMessage(){
        // construct query
        let query = PFQuery(className: "Message")
        //query.addDescendingOrder("createdAt")
        //query.includeKey("user")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        // fetch data asynchronously
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
