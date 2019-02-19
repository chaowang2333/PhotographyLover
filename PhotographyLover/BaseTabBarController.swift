//
//  BaseViewController.swift
//  PhotographyLover
//
//  Created by wc on 19/03/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import Firebase
import Photos

class BaseTabBarController: UITabBarController,LoginDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // camera, album
    var photoPicker : UIImagePickerController!
    var pickPhotoAlertController : UIAlertController!
    var needShowPhotoPicker : Bool = false
    var currentTag : Int = 0
    var camaraInfo : CameraInfo?
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initPhotoPicker()
        self.initAlertController()
        for item in self.tabBar.items! {
            let barItem = item as UITabBarItem
            if barItem.tag == 2 {
                // middle button image
                let image = UIImage(named: "camera")
                barItem.image = image?.withRenderingMode(.alwaysOriginal)
                barItem.selectedImage?.withRenderingMode(.alwaysOriginal)
            }
            // set tabbaritem image in center
            barItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }
    }
    
    // login cancel
    func loginCancel(tab: Int?) {
        self.selectedIndex = currentTag
    }
    
    // login succeed
    func loginSucceed(tab: Int?) {
        if tab == 2
        {
            needShowPhotoPicker = true
        }
    }
    
    // init alert controller
    func initAlertController()
    {
        self.pickPhotoAlertController = UIAlertController(title:nil, message: nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        let takePhoto = UIAlertAction(title:"Camera", style:UIAlertActionStyle.default) { (action:UIAlertAction)in
            // check if camera available
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.photoPicker.sourceType = .camera
                self.present(self.photoPicker, animated: true, completion: nil)
            }
            else
            {
                self.showFailMessage(view: self.view, message: "Camera is not available!")
            }
        }
        let photoLib = UIAlertAction(title:"Album", style:UIAlertActionStyle.default) { (action:UIAlertAction)in
            self.photoPicker.sourceType = .photoLibrary
            self.present(self.photoPicker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel) { (action:UIAlertAction)in
            self.selectedIndex = self.currentTag
        }
        self.pickPhotoAlertController?.addAction(takePhoto)
        self.pickPhotoAlertController?.addAction(photoLib)
        self.pickPhotoAlertController?.addAction(cancel)
    }
    
    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        
        if needShowPhotoPicker
        {
            present(self.pickPhotoAlertController, animated: false, completion: {
                //self.selectedIndex = self.currentTag
            })
            needShowPhotoPicker = false
        }
        if selectedIndex == 2
        {
            // never select middle tab button
            self.selectedIndex = currentTag
        }
    }
    
    // UITabBarItem did selected
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2
        {
            // pick photo
            if (FIRAuth.auth()?.currentUser) != nil
            {
                present(self.pickPhotoAlertController, animated: false, completion: {
                    self.selectedIndex = self.currentTag
                })
                return
            } else {
                let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
                loginVC.delegate = self
                loginVC.tabIndex = 2
                let nc = MyNavigaController(rootViewController: loginVC)
                present(nc, animated: true, completion: nil)
            }
        }
        else if item.tag == 4
        {
            // me
            if FIRAuth.auth()?.currentUser == nil
            {
                let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
                loginVC.delegate = self
                loginVC.tabIndex = 4
                let nc = MyNavigaController(rootViewController: loginVC)
                present(nc, animated: true, completion: nil)
            }
            else
            {
                self.currentTag = item.tag
            }
        }
        else
        {
            self.currentTag = item.tag
        }
    }
    
    // init photo picker
    func initPhotoPicker(){
        photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
    }
    
    // finish pick image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        // if it's a photo from the library, not an image from the camera
        if #available(iOS 8.0, *), let referenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceUrl], options: nil)
            let asset = assets.firstObject
            asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
                let imageFile = contentEditingInput?.fullSizeImageURL
                var imageData = NSData(contentsOf: imageFile!)
                let image = UIImage(data: imageData as! Data)
                imageData = self.resizeImage(originalImg: image!)
                //imageData = UIImagePNGRepresentation(image!)! as NSData?
                // jump to add tag screen
                let addTagVC = AddTagViewController(nibName: "AddTagViewController", bundle: nil)
                addTagVC.imageData = imageData
                let nc = MyNavigaController(rootViewController: addTagVC)
                self.present(nc, animated: true, completion: nil)
                return
            })
        } else {
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
            let imageData = self.resizeImage(originalImg: image)
            let metaDataDicRef = info[UIImagePickerControllerMediaMetadata]
            camaraInfo = CameraInfo()
            if metaDataDicRef != nil
            {
                // get camera settings
                let dic = metaDataDicRef as! NSDictionary
                let exifDic = dic[kCGImagePropertyExifDictionary] as! NSDictionary
                let shutter = exifDic[kCGImagePropertyExifShutterSpeedValue]
                if shutter != nil
                {
                    camaraInfo?.shutter = NSString(format: "%.5f" , (shutter as! NSNumber).doubleValue / 100.0)
                }
                let aperture = exifDic[kCGImagePropertyExifApertureValue]
                if aperture != nil
                {
                    camaraInfo?.aperture = NSString(format: "%.1f" , (aperture as! NSNumber).doubleValue)
                }
                let iso = exifDic[kCGImagePropertyExifISOSpeedRatings]
                if iso != nil
                {
                    if (iso as! NSArray).count != 0
                    {
                        camaraInfo?.iso = NSString(format: "%.0f" , ((iso as! NSArray)[0] as! NSNumber).doubleValue)
                    }
                }
                print(exifDic)
            }
            // get device name
            let deviceName = UIDevice.current.modelName
            camaraInfo?.camera = deviceName as NSString
            let addTagVC = AddTagViewController(nibName: "AddTagViewController", bundle: nil)
            addTagVC.imageData = imageData
            addTagVC.cameraInfo = camaraInfo
            let nc = MyNavigaController(rootViewController: addTagVC)
            self.present(nc, animated: true, completion: nil)
        }
    }
    
    // compress image
    func compressImageSize(image:UIImage) -> NSData{
        let originalImgSize = (UIImagePNGRepresentation(image)! as NSData?)?.length
        var zipImageData : NSData? = nil
        if originalImgSize!>1500 {
            zipImageData = UIImageJPEGRepresentation(image,0.3)! as NSData?
        }else if originalImgSize!>600 {
            zipImageData = UIImageJPEGRepresentation(image,0.4)! as NSData?
        }else if originalImgSize!>400 {
            zipImageData = UIImageJPEGRepresentation(image,0.5)! as NSData?
        }else if originalImgSize!>300 {
            zipImageData = UIImageJPEGRepresentation(image,0.6)! as NSData?
        }else if originalImgSize!>200 {
            zipImageData = UIImageJPEGRepresentation(image,0.7)! as NSData?
        }
        return zipImageData!
    }
    
    // resize image
    private func resizeImage(originalImg:UIImage) -> NSData{
        
        //prepare constants
        let width = originalImg.size.width
        let height = originalImg.size.height
        let scale = width/height
        
        var sizeChange = CGSize()
        
        if width <= 1280 && height <= 1280{
            //keep size
            return compressImageSize(image: originalImg)
        }else if width > 1280 || height > 1280 {
            // change width or height to 1280
            if scale <= 2 && scale >= 1 {
                let changedWidth:CGFloat = 1280
                let changedheight:CGFloat = changedWidth / scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if scale >= 0.5 && scale <= 1 {
                
                let changedheight:CGFloat = 1280
                let changedWidth:CGFloat = changedheight * scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if width > 1280 && height > 1280 {
                // both resize
                if scale > 2 {
                    
                    let changedheight:CGFloat = 1280
                    let changedWidth:CGFloat = changedheight * scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }else if scale < 0.5{
                    
                    let changedWidth:CGFloat = 1280
                    let changedheight:CGFloat = changedWidth / scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }
            }else {
                // keep
                return compressImageSize(image: originalImg)
            }
        }
        
        UIGraphicsBeginImageContext(sizeChange)
        
        //draw resized image on Context
        originalImg.draw(in: CGRect(x:0, y:0, width:sizeChange.width, height:sizeChange.height))
        
        //create UIImage
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return compressImageSize(image: resizedImg!)
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
