//
//  MeViewController.swift
//  PhotographyLover
//
//  Created by wc on 8/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import Firebase
import Photos
import Kingfisher

class MeViewController: UIViewController, UICollectionViewDelegate, LogOffDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, DetailRightButtonDelegate {
    
    @IBOutlet weak var vUserLine: UIView!
    @IBOutlet weak var vUserInfo: UIView!
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var photos : [PhotoModel] = []
    
    var photoPicker : UIImagePickerController!
    var pickPhotoAlertController : UIAlertController!
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initPhotoPicker()
        self.initAlertController()
        // collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:80,height:80)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5)
        collectionView.setCollectionViewLayout(layout, animated: true)
        // collection view delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // user icon
        ivIcon.layer.cornerRadius = ivIcon.frame.width / 2.0
        ivIcon.layer.masksToBounds = true
        ivIcon.layer.borderWidth = 0.8
        ivIcon.layer.borderColor = UIColor(hexString: CONST.MAIN_GREY)?.cgColor
        ivIcon.isUserInteractionEnabled = true
        let iconTap = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        ivIcon.addGestureRecognizer(iconTap)
        // line
        vUserLine.backgroundColor = UIColor(hexString: CONST.MAIN_GREY)
        // user infor
        let tap = UITapGestureRecognizer(target: self, action: #selector(editUser))
        vUserInfo.addGestureRecognizer(tap)
        
        // upload succeed observer to reload photos
        let notificationName = Notification.Name(rawValue: "UploadSucceed")
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(requestData),
                                               name: notificationName, object: nil)
    }
    
    // pick image
    func pickImage() {
        self.present(pickPhotoAlertController, animated: true, completion: nil)
    }
    
    // init photo picker
    func initPhotoPicker(){
        photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
    }
    
    // init alert controller
    func initAlertController()
    {
        self.pickPhotoAlertController = UIAlertController(title:nil, message: nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        let takePhoto = UIAlertAction(title:"Camera", style:UIAlertActionStyle.default) { (action:UIAlertAction)in
            // check camera available
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
        }
        self.pickPhotoAlertController?.addAction(takePhoto)
        self.pickPhotoAlertController?.addAction(photoLib)
        self.pickPhotoAlertController?.addAction(cancel)
    }

    // edit user
    func editUser() {
        // jump to edit user screen
        let editVC = EditUserViewController(nibName: "EditUserViewController", bundle: nil)
        self.navigationController?.show(editVC, sender: self)
    }
    
    // log off
    func logOff() {
        self.tabBarController?.selectedIndex = 0
        (self.tabBarController as! BaseTabBarController).currentTag = 0
    }
    
    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FIRAuth.auth()?.currentUser != nil
        {
            lblName.text = FIRAuth.auth()!.currentUser!.displayName
            if ((FIRAuth.auth()!.currentUser?.photoURL) != nil) {
                ivIcon.kf.setImage(with: FIRAuth.auth()!.currentUser?.photoURL)
            }
            // if no data then request
            if self.photos.count == 0
            {
                requestData()
            }
        }
        else
        {
            lblName.text = ""
            ivIcon.image = UIImage(named: "userIcon")
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MeToSetting"
        {
            // log off delegate
            (segue.destination as! SettingViewController).delegate = self
        }
    }
    
    // did select item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
        vc.from = .me
        vc.delegate = self
        vc.setData(data: photos[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // photo deleted
    func detailRightButtonPressed(data: PhotoModel) {
        self.photos.remove(at: self.photos.index(of: data)!)
        self.collectionView.reloadData()
    }
    
    // collection view count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    // collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeCollectionViewCell", for: indexPath)  as! MeCollectionViewCell
        let url = URL(string: photos[indexPath.row].imgurl as String)
        cell.ivPhoto.kf.setImage(with: url)
        return cell
    }
    
    // request data
    func requestData() {
        // load stuff from the internet
        let ref = FIRDatabase.database().reference()
        ref.child("/user-posts/\(FIRAuth.auth()!.currentUser!.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
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
                self.collectionView.reloadData()
            }
            
        }) { (error) in
            self.showFailMessage(view: self.view, message: error.localizedDescription)
        }
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
                // set icon
                self.changeUserIcon(imageData: imageData as! Data)
            })
        } else {
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
            
            let imageData = self.resizeImage(originalImg: image)
            // set icon
            self.changeUserIcon(imageData: imageData as Data)
        }
    }
    
    // change user icon
    func changeUserIcon(imageData: Data) {
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
        // upload imge
        storageRef.child(imagePath)
            .put(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    MBProgressHUD.hide(for: self.view, animated:true)
                    self.showFailMessage(view: self.view, message: (error?.localizedDescription)!)
                    return
                }
                let downloadURL = metadata!.downloadURL()
                let user = FIRAuth.auth()?.currentUser
                // change user icon
                if let user = user {
                    let changeRequest = user.profileChangeRequest()
                    changeRequest.photoURL = downloadURL
                    changeRequest.commitChanges { error in
                        MBProgressHUD.hide(for: self.view, animated:true)
                        if error != nil
                        {
                            self.showFailMessage(view: self.view, message: (error?.localizedDescription)!)
                        } else
                        {
                            self.showSucceedMessage(view: self.view, message: "Icon Change Succeed!")
                            self.ivIcon.image =  UIImage(data: imageData)
                        }
                    }
                }
        }
    }
    
    // compress image
    func compressImageSize(image:UIImage) -> NSData{
        let originalImgSize = (UIImagePNGRepresentation(image)! as NSData?)?.length
        var zipImageData : NSData? = nil
        if originalImgSize!>1500 {
            zipImageData = UIImageJPEGRepresentation(image,0.1)! as NSData?
        }else if originalImgSize!>600 {
            zipImageData = UIImageJPEGRepresentation(image,0.2)! as NSData?
        }else if originalImgSize!>400 {
            zipImageData = UIImageJPEGRepresentation(image,0.3)! as NSData?
        }else if originalImgSize!>300 {
            zipImageData = UIImageJPEGRepresentation(image,0.4)! as NSData?
        }else if originalImgSize!>200 {
            zipImageData = UIImageJPEGRepresentation(image,0.5)! as NSData?
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
        
        if width <= 1280 && height <= 1280
        {
            //keep size
            return compressImageSize(image: originalImg)
        }
        else if width > 1280 || height > 1280
        {
            // change width or height to 1280
            if scale <= 2 && scale >= 1
            {
                let changedWidth:CGFloat = 1280
                let changedheight:CGFloat = changedWidth / scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
            }
            else if scale >= 0.5 && scale <= 1
            {
                let changedheight:CGFloat = 1280
                let changedWidth:CGFloat = changedheight * scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
            }
            else if width > 1280 && height > 1280
            {
                // both resize
                if scale > 2
                {
                    let changedheight:CGFloat = 1280
                    let changedWidth:CGFloat = changedheight * scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                }
                else if scale < 0.5
                {
                    let changedWidth:CGFloat = 1280
                    let changedheight:CGFloat = changedWidth / scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                }
            }
            else
            {
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
}
