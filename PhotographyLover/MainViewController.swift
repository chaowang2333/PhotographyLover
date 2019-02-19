//
//  MainViewController.swift
//  PhotographyLover
//
//  Created by wc on 17/04/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UITableViewController, BreakOutToRefreshDelegate, MainCellSaveSucceedDelegate {
    
    var refreshView: BreakOutToRefreshView!
    var photos : [PhotoModel] = []
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view style
        self.tableView.separatorStyle = .singleLine
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(hexString: CONST.BACKGROUND_GREY)
        self.view.backgroundColor = UIColor(hexString: CONST.BACKGROUND_GREY)
        
        // refresh view
        //let refreshHeight = CGFloat(100)
        refreshView = BreakOutToRefreshView(scrollView: tableView)
        refreshView.refreshDelegate = self
        
        // configure the refresh view
        refreshView.scenebackgroundColor = UIColor(hue: 0.68, saturation: 0.9, brightness: 0.3, alpha: 1.0)
        refreshView.paddleColor = UIColor.lightGray
        refreshView.ballColor = UIColor.white
        refreshView.blockColors = [UIColor(hue: 0.17, saturation: 0.9, brightness: 1.0, alpha: 1.0), UIColor(hue: 0.17, saturation: 0.7, brightness: 1.0, alpha: 1.0), UIColor(hue: 0.17, saturation: 0.5, brightness: 1.0, alpha: 1.0)]
        refreshView.textColor = UIColor.white
        refreshView.forceEnd = true
        tableView.addSubview(refreshView)
        requestData()
        
        // upload succeed observer to reload photos
        let notificationName = Notification.Name(rawValue: "UploadSucceed")
        NotificationCenter.default.addObserver(self, selector:#selector(requestData),
                                               name: notificationName, object: nil)
    }
    
    // request data from sever
    func requestData() {
        refreshViewDidRefresh(refreshView)
    }
    
    // scrollview did scroll
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    // scrollview will end dragging
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    // scrollview will begin dragging
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        refreshView.scrollViewWillBeginDragging(scrollView)
    }
    
    // did refrash
    func refreshViewDidRefresh(_ refreshView: BreakOutToRefreshView) {
        // load from server
        let ref = FIRDatabase.database().reference()
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get value
            let value = snapshot.value as? NSDictionary
            if value == nil
            {
                return
            }
            self.photos.removeAll()
            for key in (value?.allKeys)! {
                let p = PhotoModel()
                let dic = value?[key] as! NSDictionary
                p.imgurl = dic["img"] as! NSString
                p.uid = dic["uid"] as! NSString
                p.uname = dic["uname"] as! NSString
                p.uploaddate = dic["uploaddate"] as! NSString
                p.aperture = dic["aperture"] as! NSString
                p.shutter = dic["shutter"] as! NSString
                p.iso = dic["iso"] as! NSString
                p.desc = dic["desc"] as! NSString
                p.postid = dic["postid"] as! NSString
                p.device = dic["device"] as! NSString
                p.tags = NSArray()
                if dic.object(forKey: "tags") != nil
                {
                    let tags = NSMutableArray()
                    let a = dic["tags"] as! NSArray
                    for tt in a
                    {
                        let tdic = tt as! NSDictionary
                        let t = TagData()
                        t.left = CGFloat((tdic["left"] as? Double)!)
                        t.top = CGFloat((tdic["top"] as? Double)!)
                        t.orientation = tdic["orientation"] as? Int
                        t.text = tdic["text"] as? String
                        tags.add(t)
                    }
                    p.tags = tags
                }
                self.photos.append(p)
                self.tableView.reloadData()
            }
            refreshView.endRefreshing()
        }) { (error) in
            refreshView.endRefreshing()
            self.showFailMessage(view: self.view, message: error.localizedDescription)
        }
    }
    
    // did select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.setData(data: photos[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // section number
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    // rows number
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    // cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
        cell.setData(data: self.photos[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    // photo saved
    func photoSaved() {
        self.showSucceedMessage(view: self.view, message: "Download Succeed!")
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
