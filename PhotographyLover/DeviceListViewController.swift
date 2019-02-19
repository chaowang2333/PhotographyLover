//
//  DeviceListViewController.swift
//  PhotographyLover
//
//  Created by wc on 16/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import CoreData

class DeviceListViewController: UITableViewController, AddDeviceSucceedDelegate {
    
    var devices : [Device] = []
    var managedObjectContext : NSManagedObjectContext?
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Devices"
        // cell cannot be selected
        self.tableView.allowsSelection = false
        // set tableview style
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(hexString: CONST.BACKGROUND_GREY)
        self.view.backgroundColor = UIColor(hexString: CONST.BACKGROUND_GREY)
        // add device button
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addDevice))
        self.navigationItem.rightBarButtonItem = addButton
        
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
    
    // add device screen
    func addDevice() {
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // row count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices.count
    }
    
    // cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            managedObjectContext?.delete(devices[indexPath.row])
            devices.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
            do {
                try managedObjectContext?.save()
            } catch {
                self.showFailMessage(view: self.view, message: "Save Failed!")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
