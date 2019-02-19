//
//  LoginViewController.swift
//  PhotographyLover
//
//  Created by wc on 19/03/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import Firebase

protocol LoginDelegate {
    func loginSucceed(tab: Int?)
    func loginCancel(tab: Int?)
}

class LoginViewController: UIViewController {
    
    var delegate: LoginDelegate? = nil
    var tabIndex : Int? = 0

    @IBOutlet weak var tfName: MyTextField!
    @IBOutlet weak var tfPassword: MyTextField!
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Login"
        
        // init text field
        self.tfPassword.maxLength = 15
        self.tfPassword.tfName = "Password"
        self.tfPassword.vc = self
        
        self.tfName.maxLength = 40
        self.tfName.tfName = "Email"
        self.tfName.vc = self
    }

    // cancel
    @IBAction func cancelClicked(_ sender: Any) {
        delegate?.loginCancel(tab: self.tabIndex)
        self.dismiss(animated: true, completion: nil)
    }
    
    // sign up button pressed
    @IBAction func signUpClicked(_ sender: Any) {
        let signUpVC = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    // login button pressed
    @IBAction func loginClicked(_ sender: Any) {
        let name = tfName.text!
        let password = tfPassword.text!
        
        // check blank input
        if name == "" || password == ""
        {
            self.showFailMessage(view: self.view, message: "Have not input all the fields!")
            return
        }
        
        // login
        FIRAuth.auth()?.signIn(withEmail: name, password: password) { (user, error) in
            if user == nil
            {
                // login fail
                self.showFailMessage(view: self.view, message: (error?.localizedDescription)!)
            }
            else
            {
                // login succeed
                self.delegate?.loginSucceed(tab: self.tabIndex)
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
