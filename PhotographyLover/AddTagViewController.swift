//
//  AddTagViewController.swift
//  CBE
//
//  Created by crow on 22/11/2018.
//

import UIKit

class AddTagViewController: UIViewController, CreateTagDelegate, TagDeleteDelegate {

    @IBOutlet weak var ivPhoto: UIImageView!
    var imageData : NSData?
    var tagViews : NSMutableArray? = []
    var point : CGPoint?
    var cameraInfo : CameraInfo?
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Tag"
        ivPhoto.image = UIImage(data: imageData as! Data)
        ivPhoto.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(pressImage))
        ivPhoto.addGestureRecognizer(tapGR)
        
        // next button
        let btnNext = UIBarButtonItem(image: UIImage(named: "forward"), style: .plain, target: self, action: #selector(nextPressed))
        self.navigationItem.rightBarButtonItem = btnNext
        
        // back button
        let btnBack = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backPressed))
        self.navigationItem.leftBarButtonItem = btnBack
    }
    
    // press on image
    func pressImage(tap : UITapGestureRecognizer) {
        point = tap.location(in: tap.view)
        let createTagVC = CreateTagViewController(nibName: "CreateTagViewController", bundle: nil)
        createTagVC.createTagDelegate = self
        self.navigationController?.show(createTagVC, sender: self)
    }
    
    // create tag
    func tagCreatedWithText(text: String){
        let data = TagData()
        data.text = text
        let screenWidth = UIScreen.main.bounds.size.width
        
        if (point?.x)! <= screenWidth/2.0
        {
            data.orientation = 0
        }
        else
        {
            data.orientation = 1
        }
        data.top = (point?.y)!/screenWidth*100
        data.left = (point?.x)!/screenWidth*100
        
        let tagView = TagView()
        tagView.setData(tagData: data)
        tagView.delegate = self
        ivPhoto.addSubview(tagView)
        tagViews?.add(tagView)
    }
    
    // ask for remove tag
    func removeTagWithTag(tagView: TagView) {
        let alertVC = UIAlertController(title: "Alert", message: "Tag will be deleted?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            self.deleteOKPressed(tagView: tagView)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler:nil)
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // delete tag
    func deleteOKPressed(tagView: TagView) {
        tagViews?.remove(tagView)
        tagView.removeFromSuperview()
    }

    // next button pressed
    func nextPressed() {
        // jump to upload screen
        var tagDatas : NSMutableArray = []
        for tagView in tagViews! {
            tagDatas.add((tagView as! TagView).tagData!)
        }
        let uploadVC = UploadViewController(nibName: "UploadViewController", bundle: nil)
        uploadVC.imageData = imageData
        uploadVC.tagDatas = tagDatas
        uploadVC.cameraInfo = self.cameraInfo
        self.navigationController?.show(uploadVC, sender: self)
    }
    
    // back button pressed
    func backPressed() {
        dismiss(animated: true, completion: nil)
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
