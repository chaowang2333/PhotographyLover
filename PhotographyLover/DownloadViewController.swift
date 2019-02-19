//
//  DownloadViewController.swift
//  PhotographyLover
//
//  Created by wc on 12/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class DownloadViewController: UITableViewController, DeleteDelegate {
    
    var photos : [Photo] = []
    var managedObjectContext : NSManagedObjectContext
    
    // init controller and NSManagedObjectContext
    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        // get all photos
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Photo")
        do {
            let result = try self.managedObjectContext.fetch(fetchRequest)
            if result.count != 0
            {
                self.photos = (result as? [Photo])!
                tableView.reloadData()
            }
            print(result.description)
        } catch {
            print(error as NSError)
        }
    }
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        // table view style
        self.tableView.separatorStyle = .singleLine
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(hexString: CONST.BACKGROUND_GREY)
        self.view.backgroundColor = UIColor(hexString: CONST.BACKGROUND_GREY)
    }
    
    // did select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.setDownloadData(downloadData: photos[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    // cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    // cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadCell", for: indexPath) as! DownloadCell
        cell.setData(data: self.photos[indexPath.row])
        cell.rowIndex = indexPath.row
        cell.delegate = self
        return cell
    }
    
    // delete photo
    func deletePhoto(rowIndex: Int) {
        managedObjectContext.delete(photos[rowIndex])
        do {
            try managedObjectContext.save()
            photos.remove(at: rowIndex)
            self.tableView.reloadData()
            self.showSucceedMessage(view: self.view, message: "Delete Succeed!")
        } catch {
            self.showFailMessage(view: self.view, message: "Delete Failed!")
        }
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
