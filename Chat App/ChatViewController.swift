//
//  ChatViewController.swift
//  Chat App
//
//  Created by Mohamed on 1/11/18.
//  Copyright © 2018 Mohamed. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    var messagesArray: [Message] = [Message]()

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        messageTextField.delegate = self
        
        //tap gesture
        // so we create a tapgesture when we tap any where in our table it will trigger the table
        // view tapped func which in turn will trigger our end editing func
        let tapGesture = UITapGestureRecognizer(target: self, action:  #selector(tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
        
        
        tableView.register(UINib(nibName: "customMessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retrieveMessages()
        
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messagesArray.count
    }
    
   
    // gets triggered with every new cell created
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! customMessageCell
        
   cell.messageBody.text = messagesArray[indexPath.row].messageBody
   cell.senderUserName.text = messagesArray[indexPath.row].sender
        
   cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUserName.text == FIRAuth.auth()?.currentUser?.email as! String
        {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }
        else
        {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    //adjust our label hight to fit the content of every message
    func configureTableView(){
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
    }
    
    
    //decleare text field did begin editing means that user began to edit or type in messagetextfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
         self.heightConstraint.constant = 326 // change the height automatically so that the keyboard can not hide our view(textfield + send button)
        
        UIView.animate(withDuration: 0.5){
           
            self.view.layoutIfNeeded() // if something or a constraint has changed re draw the whole thing
        }
        
    }
    
    // declare text field did end editing means that user end his typing
    // this method doen't work automatic like didbeginediting so we have to call it manually
    //so when we tap at any where it should hide
    func textFieldDidEndEditing(_ textField: UITextField) {
        
         self.heightConstraint.constant = 68
        
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
        
    }
    
    // declare tableviewtapped func
    @objc func tableViewTapped(){
        messageTextField.endEditing(true)
    }
    
    
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        messageTextField.endEditing(true) // we we click send the view gets to its normal view
        
        // when we click the send button the data should be saved on our firebase
        
        //we need disable the send and textfield some little time while the data beening saved on firebase
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        
        let messagesDB = FIRDatabase.database().reference().child("Messages") // we create a subdatabase inside our big database which responsible for messages
        
        let messageDict = ["Sender": FIRAuth.auth()?.currentUser?.email, "MessageBody": messageTextField.text!]
        
        messagesDB.childByAutoId().setValue(messageDict) // we save our messages (message dictionary) in our messages database under a random id or key
        {
            (error , ref) in
            if error != nil
            {
                print(error?.localizedDescription)
            }
            else
            {
                print("Message saved successfully!")
                
                // and we enable out textfield and send button
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                
                // and we clear our textfield from the old message
                self.messageTextField.text = ""
            }
        }
    }
    
    
    // func to retrieve messages here
    
    func retrieveMessages(){
        
        let messagesDB = FIRDatabase.database().reference().child("Messages")
        // we have to enter the same database we create to receive and send messages
        
        // this closure will get called whenever a new messages added to our database
        messagesDB.observe(.childAdded, with: { (snapshot) in
       
            // snapshot of our database (messages)
            
            // snapshot value is an any the compiler can not recognize any type so we have to convert it into something the compiler understands it , we put our data as a dictionary so we will convert our snapshot value to a dictionary like apis
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
  //we here force unwrapp it because this closure only trigers if anew item is added to our database wont trigger if it is empty
            let sender = snapshotValue["Sender"]!
            let text = snapshotValue["MessageBody"]!
           // print(Sender , Message)
            
            // we load our messages and sender to our messages class which includes the message details
            
            let messageObj = Message()
            
            messageObj.messageBody = text
            messageObj.sender = sender
            
            // we append our object to our array of objects
            self.messagesArray.append(messageObj)
            
            self.configureTableView() // to make the hight fit every message
            
            self.tableView.reloadData() // when add new data we need to reload our table view
            
        })
        
    }
    
    
    
    
    @IBAction func logOutButtonClicked(_ sender: Any) {
        
        do {
            
            try FIRAuth.auth()?.signOut()
            
        }catch{
            print(error.localizedDescription)
        }
        
      guard (navigationController?.popToRootViewController(animated: true)) != nil
        else{
            print("threre is no more views")
            return
        }
        
        
    }
    

}
