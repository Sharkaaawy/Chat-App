//
//  RegisterViewController.swift
//  Chat App
//
//  Created by Mohamed on 1/11/18.
//  Copyright © 2018 Mohamed. All rights reserved.
//

import UIKit
import Firebase
import  SVProgressHUD

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

  
    @IBAction func registerButton(_ sender: Any) {
        
        
        SVProgressHUD.show()
        
        
        
        //to setup a new user on our firebase database
        // while the process of reisteration is happening ,the UI gets frozen
        //completion is a closure that notify that a process is completed
        //here once the process of registeration is completed it triggered with some info
        
        
        
        
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in  //once the comlpetion is completed it will return to us with user info or an error occured
            //callback is a message that gets trigered once a process of creating user completed
        // once we get that callback message our app can continue and use some of info we got
            
            if error != nil
            {
                print(error?.localizedDescription)
            }
            else
            {
                
                print("Registeration successful!")
                //when we call a method inside a closure we should use self. so the compiler recongnize it
                // this class inherit the perform segue method from the uiviewcontroller
                
                SVProgressHUD.dismiss()
                
                
                self.performSegue(withIdentifier: "registerGoToChat", sender: self)
            }
        })
        
    }
    
}
