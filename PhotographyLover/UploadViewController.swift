//
//  UploadViewController.swift
//  PhotographyLover
//
//  Created by wc on 7/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, ChooseDeviceDelegate, UITextViewDelegate {
    @IBOutlet weak var btnDevice: MyButton!
    @IBOutlet weak var tfShutter: MyTextField!
    @IBOutlet weak var lblDevice: UILabel!
    @IBOutlet weak var tvDesc: UITextView!
    @IBOutlet weak var tfIso: MyTextField!
    @IBOutlet weak var tfAperture: MyTextField!
    @IBOutlet weak var ivPhoto: UIImageView!
    var imageData : NSData?
    var tagDatas : NSMutableArray = []
    var photoModel : PhotoModel = PhotoModel()
    var deviceName : String = ""
    var cameraInfo : CameraInfo?
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        ivPhoto.image = UIImage(data: imageData as! Data)
        
        self.title = "Upload"
        
        // init textfield
        tfShutter.tfName = "Shutter"
        tfShutter.maxLength = 7
        tfShutter.vc = self
        tfAperture.tfName = "Aperture"
        tfAperture.maxLength = 4
        tfAperture.vc = self
        tfIso.tfName = "ISO"
        tfIso.maxLength = 5
        tfIso.vc = self
        
        // confirm button
        let btnNext = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(confirmPressed))
        self.navigationItem.rightBarButtonItem = btnNext
        
        // description textview
        tvDesc.delegate = self
        tvDesc.layer.masksToBounds = true
        tvDesc.layer.cornerRadius = 4
        tvDesc.layer.borderWidth = 0.8
        tvDesc.layer.borderColor = UIColor(hexString:CONST.MAIN_RED)?.cgColor
        
        // if from camera
        if cameraInfo != nil
        {
            tfShutter.text = cameraInfo?.shutter as String?
            tfAperture.text = cameraInfo?.aperture as String?
            tfIso.text = cameraInfo?.iso as String?
            if cameraInfo?.camera != ""
            {
                self.deviceName = cameraInfo?.camera as! String
                self.lblDevice.text = "Device: " + (cameraInfo?.camera as! String)
                self.btnDevice.isHidden = true
            }
        }
    }
    
    // view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        // layout
        let screenWidth = UIScreen.main.bounds.width
        self.ivPhoto.frame = CGRect(x: screenWidth - self.ivPhoto.frame.width - 15, y: self.ivPhoto.frame.origin.y, width: self.ivPhoto.frame.width, height: self.ivPhoto.frame.height)
        self.tvDesc.frame = CGRect(x: self.tvDesc.frame.origin.x, y: self.tvDesc.frame.origin.y, width: screenWidth - self.tvDesc.frame.origin.x - 15, height: self.tvDesc.frame.height)
    }
    
    // choose button pressed
    @IBAction func choosePressed(_ sender: Any) {
        let chooseVC = ChooseDeviceViewController()
        chooseVC.delegate = self
        self.navigationController?.pushViewController(chooseVC, animated: true)
    }
    
    // choose device
    func chooseDevice(deviceName: String) {
        self.deviceName = deviceName
        self.lblDevice.text = "Device: " + deviceName
    }
    
    // confirm button pressed
    func confirmPressed() {
        if tfIso.text == "" || tfShutter.text == "" || tfAperture.text == ""
        {
            showFailMessage(view: self.view, message: "Please fill in Shutter, Aperture and ISO!")
            return
        }
        photoModel = PhotoModel()
        photoModel.aperture = (tfAperture.text as NSString?)!
        photoModel.iso = (tfIso.text as NSString?)!
        photoModel.shutter = (tfShutter.text as NSString?)!
        photoModel.desc = (tvDesc.text as NSString?)!
        photoModel.uploaddate = (Date().description as NSString?)!
        photoModel.device = self.deviceName as NSString
        photoModel.uid = (FIRAuth.auth()!.currentUser!.uid as NSString?)!
        if FIRAuth.auth()!.currentUser!.displayName != nil
        {
            photoModel.uname = (FIRAuth.auth()!.currentUser!.displayName as NSString?)!
        }
        // show progresshud
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Uploading"
        
        let storage = FIRStorage.storage()
        // Create a root reference
        let storageRef = storage.reference()
        let imagePath = FIRAuth.auth()!.currentUser!.uid +
        "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        // upload image
        storageRef.child(imagePath)
            .put(imageData as! Data, metadata: metadata) { (metadata, error) in
                if error != nil {
                    MBProgressHUD.hide(for: self.view, animated:true)
                    self.showFailMessage(view: self.view, message: (error?.localizedDescription)!)
                    return
                }
                let downloadURL = metadata!.downloadURL()
                let ref = FIRDatabase.database().reference()
                self.photoModel.imgurl = (downloadURL!.absoluteString as NSString?)!
                
                var array = [NSDictionary]()
                for tagData in self.tagDatas
                {
                    let data = tagData as! TagData
                    array.append(["text":data.text as Any, "top":data.top as Any, "left":data.left as Any,"orientation":data.orientation as Any])
                }
                let key = ref.child("posts").childByAutoId().key
                self.photoModel.postid = key as NSString
                let post = ["img": self.photoModel.imgurl,"postid": self.photoModel.postid, "uname": self.photoModel.uname, "uid": self.photoModel.uid, "uploaddate": self.photoModel.uploaddate, "aperture": self.photoModel.aperture, "iso": self.photoModel.iso,"shutter": self.photoModel.shutter, "device": self.photoModel.device, "desc": self.photoModel.desc, "tags":array] as [String : Any]
                let childUpdates = ["/posts/\(key)": post,
                                    "/user-posts/\(self.photoModel.uid)/\(key)/": post]
                // upload photo info
                ref.updateChildValues(childUpdates, withCompletionBlock: { (err, comRef) in
                    if err != nil
                    {
                        MBProgressHUD.hide(for: self.view, animated:true)
                        self.showFailMessage(view: self.view, message: (err?.localizedDescription)!)
                        return
                    }
                    else
                    {
                        let notificationName = Notification.Name(rawValue: "UploadSucceed")
                        NotificationCenter.default.post(name: notificationName, object: self, userInfo: nil)
                        MBProgressHUD.hide(for: self.view, animated:true)
                        self.dismiss(animated: true, completion: nil)
                    }
                })
        }
    }
    
    // text view did change
    func textViewDidChange(_ textView: UITextView) {
            let selectRange = textView.markedTextRange
            
            // select range
            if let selectRange = selectRange {
                let position =  textView.position(from: (selectRange.start), offset: 0)
                if (position != nil) {
                    return
                }
            }
            
            let textContent = textView.text
            let textNum = textContent?.characters.count
            
            // max 250 characters
            if textNum! > 250 {
                let index = textContent?.index((textContent?.startIndex)!, offsetBy: 250)
                let str = textContent?.substring(to: index!)
                textView.text = str
                self.showFailMessage(view: self.view, message: "Description cannot exceed 250!")
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
