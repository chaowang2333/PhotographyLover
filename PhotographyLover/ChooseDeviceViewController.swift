//
//  ChooseDeviceViewController.swift
//  PhotographyLover
//
//  Created by wc on 16/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import CoreData

// choose device delegate
protocol ChooseDeviceDelegate {
    func chooseDevice(deviceName: String)
}

class ChooseDeviceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddDeviceSucceedDelegate {
    
    var devices : [Device] = []
    var managedObjectContext : NSManagedObjectContext?
    var delegate : ChooseDeviceDelegate?
   
    @IBOutlet weak var tableView: UITableView!
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Choose Device"
        
        // confirm button
        let btnNext = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addPressed))
        self.navigationItem.rightBarButtonItem = btnNext
        
        // set delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // set tableview style
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(hexString: CONST.BACKGROUND_GREY)
        self.view.backgroundColor = UIColor(hexString: CONST.BACKGROUND_GREY)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        // get all devices
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Device")
        do {
            let result = try self.managedObjectContext?.fetch(fetchRequest)
            if result?.count != 0
            {
                self.devices = (result as? [Device])!
                tableView.reloadData()
            }
        } catch {
            self.showFailMessage(view: self.view, message: "Fetch Failed!")
        }
    }
    
    // add device button pressed
    func addPressed() {
        let addVC = AddDeviceViewController()
        addVC.delegate = self
        self.navigationController?.show(addVC, sender: self)
    }
    
    // add device succeed
    func addDeviceSucceed(device: Device) {
        self.devices.append(device)
        self.tableView.reloadData()
    }

    // section count
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices.count
    }
    
    // cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell")
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "deviceCell")
            
        }
        // add bottom line
        for view in (cell?.subviews)! {
            if view.tag == 101
            {
                view.removeFromSuperview()
            }
        }
        if indexPath.row != (devices.count - 1)
        {
            let line = UIView()
            let width = UIScreen.main.bounds.width
            line.frame = CGRect(x: 15, y: (cell?.frame.height)!-0.5, width: width-30, height: 0.5)
            line.tag = 101
            line.backgroundColor = UIColor(hexString: CONST.MAIN_GREY)
            cell?.addSubview(line)
        }
        cell?.textLabel?.text = self.devices[indexPath.row].name
        return cell!
    }
    
    // delete device
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            managedObjectContext?.delete(devices[indexPath.row])
            devices.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
            do {
                try managedObjectContext?.save()
            } catch {
                showFailMessage(view: self.view, message: "Delete Failed!")
            }
        }
    }
    
    // did select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.chooseDevice(deviceName: devices[indexPath.row].name!)
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

