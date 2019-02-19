//
//  SignUpViewController.swift
//  PhotographyLover
//
//  Created by wc on 19/03/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
   
    var delegate: LoginDelegate? = nil

    @IBOutlet weak var tfRePassword: MyTextField!
    @IBOutlet weak var tfNick: MyTextField!
    @IBOutlet weak var tfUserName: MyTextField!
    @IBOutlet weak var tfPassword: MyTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sign Up"
        
        // init text field
        self.tfRePassword.maxLength = 15
        self.tfRePassword.tfName = "Password"
        self.tfRePassword.vc = self
        
        self.tfPassword.maxLength = 15
        self.tfPassword.tfName = "Password"
        self.tfPassword.vc = self
        
        self.tfUserName.maxLength = 40
        self.tfUserName.tfName = "Email"
        self.tfUserName.vc = self
        
        self.tfNick.maxLength = 20
        self.tfNick.tfName = "Nick Name"
        self.tfNick.vc = self
    }

    // sign up
    @IBAction func signUp(_ sender: Any) {
        let name = tfUserName.text!
        let password = tfPassword.text!
        let rePassword = tfRePassword.text!
        let nick = tfNick.text!
        
        // check blank input
        if name == "" || password == "" || nick == "" || rePassword == ""
        {
            self.showFailMessage(view: self.view, message: "Have not input all the fields!")
            return
        }
        else if (password != rePassword)
        {
            // check password and re-enter password
            self.showFailMessage(view: self.view, message: "Passwords are not same!")
            return
        }
        
        // create user
        FIRAuth.auth()?.createUser(withEmail: name, password: password) { (user, error) in
            // ...
            if user == nil
            {
                // create fail
                self.showFailMessage(view: self.view, message: (error?.localizedDescription)!)
            }
            else
            {
                // upload user name
                let user = FIRAuth.auth()?.currentUser
                if let user = user {
                    let changeRequest = user.profileChangeRequest()
                    changeRequest.displayName = nick
                    changeRequest.commitChanges { error in
                        if error != nil {
                            // An error happened.
                        } else {
                            // Profile updated.
                        }
                    }
                }
               self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
