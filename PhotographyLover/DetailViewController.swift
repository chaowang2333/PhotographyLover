//
//  DetailViewController.swift
//  PhotographyLover
//
//  Created by wc on 8/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import Firebase


@objc protocol DetailRightButtonDelegate {
    @objc optional func detailRightButtonPressed(data: PhotoModel)
    @objc optional func detailRightButtonPressed(downloadData: Photo)
}
enum FromScreen {
    case main
    case download
    case me
}
class DetailViewController: UIViewController {

    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDevice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblIso: UILabel!
    @IBOutlet weak var lblApeture: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblShutter: UILabel!
    @IBOutlet weak var ivPhoto: UIImageView!
    
    var data : PhotoModel?
    var downloadData : Photo?
    var from : FromScreen = FromScreen.main
    var delegate : DetailRightButtonDelegate?
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail"
        
        // tap gesture on image view
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideTags))
        ivPhoto.isUserInteractionEnabled = true
        ivPhoto.addGestureRecognizer(tap)
        
        // set layout
        lblShutter.layer.cornerRadius = 5
        lblShutter.layer.masksToBounds = true
        lblApeture.layer.cornerRadius = 5
        lblApeture.layer.masksToBounds = true
        lblIso.layer.cornerRadius = 5
        lblIso.layer.masksToBounds = true
        
        // right button
        let btnRight = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(rightPressed))
        self.navigationItem.rightBarButtonItem = btnRight
        
        // right button
        switch from {
        case FromScreen.main:
            //btnRight.title = "Save"
            break
        case FromScreen.download:
            //btnRight.title = "Delete"
            break
        case FromScreen.me:
            btnRight.title = "Delete"
            break
        }
        
        if data != nil
        {
            lblShutter.text = " Shutter: " + (data!.shutter as String?)! + " "
            lblIso.text = " ISO: " + (data!.iso as String?)! + " "
            lblApeture.text = " Aperture: " + (data!.aperture as String?)! + " "
            lblName.text = (data!.uname as String?)!
            var date = (data!.uploaddate as String?)!
            date = date.replacingOccurrences(of: "+0000", with: "")
            lblDate.text = date
            if data!.device == ""
            {
                lblDevice.text = ""
            }
            else
            {
                lblDevice.text = data!.device as String
            }
            if data!.desc == ""
            {
                lblDesc.text = ""
            }
            else
            {
                lblDesc.text = data!.desc as String
            }
            let url = URL(string: data!.imgurl as String)
            ivPhoto.kf.setImage(with: url)
            for v in ivPhoto.subviews
            {
                v.removeFromSuperview()
            }
            for tagData in data!.tags
            {
                let disTag = TagDisplayView()
                disTag.setData(tagData: tagData as! TagData)
                ivPhoto.addSubview(disTag)
            }
        }
        
        if downloadData != nil
        {
            lblShutter.text = " Shutter: " + (downloadData!.shutter as String?)! + " "
            lblIso.text = " ISO: " + (downloadData!.iso as String?)! + " "
            lblApeture.text = " Aperture: " + (downloadData!.aperture as String?)! + " "
            lblName.text = (downloadData!.uname as String?)!
            var date = (downloadData!.uploaddate as String?)!
            date = date.replacingOccurrences(of: "+0000", with: "")
            lblDate.text = date
            if downloadData?.img != nil
            {
                ivPhoto.image = UIImage(data: downloadData!.img as! Data)
            }
            if downloadData!.device! == ""
            {
                lblDevice.text = ""
            }
            else
            {
                lblDevice.text = downloadData!.device! as String
            }
            if downloadData!.desc! == ""
            {
                lblDesc.text = ""
            }
            else
            {
                lblDesc.text = downloadData!.desc! as String
            }
            for v in ivPhoto.subviews
            {
                v.removeFromSuperview()
            }
            for tagData in downloadData!.tags!
            {
                let disTag = TagDisplayView()
                disTag.setData(tagData: tagData as! TagData)
                ivPhoto.addSubview(disTag)
            }
        }
    }
    
    // right button pressed
    func rightPressed() {
        switch from {
        case FromScreen.main:
            break
        case FromScreen.download:
            break
        case FromScreen.me:
            let ref = FIRDatabase.database().reference()
            let key = self.data?.postid
            let postKey = "/posts/" + (key as! String)
            let userKey = "/user-posts/" + (self.data?.uid as! String) + "/" + (key as! String)
            ref.child(postKey).removeValue(completionBlock: { (err, r) in
                if err == nil
                {
                    ref.child(userKey).removeValue(completionBlock: { (err, r) in
                        if err == nil
                        {
                            self.delegate?.detailRightButtonPressed!(data: self.data!)
                            self.showSucceedMessage(view: self.view, message: "Delete Succeed!")
                            self.navigationController?.popViewController(animated: true)
                        }
                        else
                        {
                            self.showFailMessage(view: self.view, message: (err?.localizedDescription)!)
                        }
                    })
                }
                else
                {
                    self.showFailMessage(view: self.view, message: (err?.localizedDescription)!)
                }
            })
            break
        }
    }

    // set data
    func setData(data: PhotoModel) {
        self.data = data
    }
    
    // set download data
    func setDownloadData(downloadData: Photo) {
        self.downloadData = downloadData
    }

    // hide or display tags
    func hideTags() {
        for v in ivPhoto.subviews
        {
            v.isHidden = !(v.isHidden)
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
