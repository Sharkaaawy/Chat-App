//
//  LogInViewController.swift
//  Chat App
//
//  Created by Mohamed on 1/11/18.
//  Copyright © 2018 Mohamed. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func logInButtonClicked(_ sender: Any) {
        
        SVProgressHUD.show()  // to imporove the UX
        
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            else{
                print("Login Successful!")
                
                
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "logInGoToChat", sender: self)
            }
        })
        
    }
    
}
