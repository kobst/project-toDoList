//
//  LoginViewController.swift
//  ToDoList
//
//  Created by Edward Han on 1/8/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    
    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    
    @IBAction func signUp(_ sender: Any) {
        let email = emailField.text
        let userName = userNameField.text
        let password = passwordField.text
        
        if email == nil || userName == nil ||
            password! == nil {
            print("do it again")
            
        }
        
        else {
            FIRAuth.auth()?.createUser(withEmail: email!, password: password!) { (user, error) in
                if let _ = error {
                    print("do it again again")
                }
                if let userGood = user {
                    Model.shared.createUserList(uid: userGood.uid, name: userName!)
                    Model.shared.currentUserPath = userGood.uid
                    
                    self.performSegue(withIdentifier: "toList", sender: self)
                    
                }
            }
        }

    }
    
    
    
    
    
    
    @IBAction func logIn(_ sender: Any) {
        let email = emailField.text
        let userName = userNameField.text
        let password = passwordField.text
        
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
        
                    if let err = error {
                        print(err)
                    }
        
                    if let userGood = user {
        
        
                        Model.shared.printUserName(uid: userGood.uid)
        
                        Model.shared.currentUserPath = userGood.uid
        
                        self.performSegue(withIdentifier: "toList", sender: self)
                
        
                    }
                    // ...
                }
        
    
    }
    
    
    
    

//    override func performSegue(withIdentifier identifier: String, sender: Any?) {}
    
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    //    func signIn(email: String, password: String) {
    //        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
    //
    //            if let err = error {
    //                print(err)
    //            }
    //
    //            if let userGood = user {
    //
    //
    //                Model.shared.printUserName(uid: userGood.uid)
    //
    //                Model.shared.currentUserPath = userGood.uid
    //
    //
    //
    //            }
    //            // ...
    //        }
    //        
    //    }



    
    
    

}
