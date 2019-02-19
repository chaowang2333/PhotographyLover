//
//  SettingViewController.swift
//  PhotographyLover
//
//  Created by wc on 15/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import Firebase

protocol LogOffDelegate {
    func logOff()
}

class SettingViewController: UITableViewController {
    
    var delegate : LogOffDelegate? = nil
    let line : UIView = UIView()
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title
        self.title = "Setting"
        
        // set tableview style
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(hexString: CONST.BACKGROUND_GREY)
        self.view.backgroundColor = UIColor(hexString: CONST.BACKGROUND_GREY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // section number
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // did select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                // manage device
                let vc = DeviceListViewController()
                self.navigationController?.show(vc, sender: self)
            }
            else if indexPath.row == 1
            {
                // about page
                let vc = AboutViewController()
                self.navigationController?.show(vc, sender: self)
            }
        }
        else
        {
            // log off
            if ((FIRAuth.auth()?.currentUser) != nil){
                do {
                    try FIRAuth.auth()?.signOut()
                    delegate?.logOff()
                    self.navigationController?.popViewController(animated: false)
                } catch {
                    self.showFailMessage(view: self.view, message: "Log off Failed!")
                }
            }
        }
    }

    // row number
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 2
        }
        return 1
    }
    
    // section header view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 10)
        view.backgroundColor = UIColor(hexString: CONST.BACKGROUND_GREY)
        return view
    }
    
    // section header height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // tableview cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.text = "Manage My Devices"
                line.frame = CGRect(x: 15, y: cell.bounds.height - 0.5, width: cell.bounds.width - 15, height: 0.5)
                line.backgroundColor = UIColor(hexString: CONST.MAIN_GREY)
                line.removeFromSuperview()
                cell.addSubview(line)
            }
            else if indexPath.row == 1
            {
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.text = "About"
            }
        }
        else
        {
            cell.textLabel?.textColor = UIColor(hexString: CONST.MAIN_RED)
            cell.textLabel?.text = "Log off"
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
