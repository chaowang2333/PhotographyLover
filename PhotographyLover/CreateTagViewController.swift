//
//  CreateTagViewController.swift
//  CBE
//
//  Created by crow on 22/11/2018.
//

import UIKit

// create tag delegate
protocol CreateTagDelegate {
    func tagCreatedWithText(text: String)
}

class CreateTagViewController: UIViewController {

    @IBOutlet weak var tfText: MyTextField!
    var createTagDelegate: CreateTagDelegate?
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Tag"
        
        // init textfield
        tfText.tfName = "Tag Text"
        tfText.maxLength = 20
        tfText.vc = self
        
        // create button
        let btnNext = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createPressed))
        self.navigationItem.rightBarButtonItem = btnNext
    }

    // create button pressed
    func createPressed() {
        if (tfText.text == "")
        {
            showFailMessage(view: self.view, message: "Please input text!")
            return
        }
        createTagDelegate?.tagCreatedWithText(text: tfText.text!)
        self.navigationController?.popViewController(animated: true)
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
