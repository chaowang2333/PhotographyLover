//
//  AddDeviceViewController.swift
//  PhotographyLover
//
//  Created by wc on 16/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import CoreData

protocol AddDeviceSucceedDelegate {
    func addDeviceSucceed(device: Device)
}

class AddDeviceViewController: UIViewController {

    @IBOutlet weak var tfName: MyTextField!
    var managedObjectContext : NSManagedObjectContext?
    var delegate : AddDeviceSucceedDelegate?
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Device"
        // add device button
        let confirmButton = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(confirm))
        self.navigationItem.rightBarButtonItem = confirmButton
        // manage object
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        // text field
        tfName.tfName = "Device name"
        tfName.maxLength = 15
        tfName.vc = self
    }
    
    // confirm button pressed
    func confirm() {
        if tfName.text == ""
        {
            self.showFailMessage(view: self.view, message: "Device name cannot be blank!")
            return
        }
        let d = NSEntityDescription.insertNewObject(forEntityName: "Device", into: managedObjectContext!) as? Device
        d?.name = tfName.text
        saveRecords(device: d!)
    }
    
    // save records
    func saveRecords(device: Device)
    {
        do {
            try self.managedObjectContext?.save()
            delegate?.addDeviceSucceed(device: device)
            self.navigationController?.popViewController(animated: true)
        } catch {
            self.showFailMessage(view: self.view, message: "Save Failed!")
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
