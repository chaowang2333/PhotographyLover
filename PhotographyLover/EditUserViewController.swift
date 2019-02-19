//
//  EditUserViewController.swift
//  PhotographyLover
//
//  Created by wc on 15/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import Firebase

class EditUserViewController: UIViewController {

    @IBOutlet weak var tfNick: MyTextField!
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit User"
        
        // init text field
        self.tfNick.maxLength = 20
        self.tfNick.tfName = "Nick Name"
        self.tfNick.vc = self
        
        // confirm button
        let btnNext = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(confirmPressed))
        self.navigationItem.rightBarButtonItem = btnNext
    }

    // comfirm pressed
    func confirmPressed() {
        let nick = tfNick.text!
        
        if nick == ""
        {
            self.showFailMessage(view: self.view, message: "Have not input nick name!")
            return
        }
        
        // edit user name
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            let changeRequest = user.profileChangeRequest()
            changeRequest.displayName = nick
            changeRequest.commitChanges { error in
                if error != nil {
                    self.showFailMessage(view: self.view, message: (error?.localizedDescription)!)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
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
