//
//  MainCell.swift
//  PhotographyLover
//
//  Created by wc on 8/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData

protocol MainCellSaveSucceedDelegate {
    func photoSaved()
}

class MainCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblIso: UILabel!
    @IBOutlet weak var lblApeture: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblShutter: UILabel!
    @IBOutlet weak var ivPhoto: UIImageView!
    var managedObjectContext : NSManagedObjectContext
    var data : PhotoModel = PhotoModel()
    var delegate : MainCellSaveSucceedDelegate?
    
    // init NSManagedObjectContext
    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    // init
    override func awakeFromNib() {
        super.awakeFromNib()
        // layout
        lblShutter.layer.cornerRadius = 5
        lblShutter.layer.masksToBounds = true
        lblApeture.layer.cornerRadius = 5
        lblApeture.layer.masksToBounds = true
        lblIso.layer.cornerRadius = 5
        lblIso.layer.masksToBounds = true
    }
    
    // set data
    func setData(data: PhotoModel) {
        self.data = data
        lblShutter.text = " Shutter: " + (data.shutter as String?)! + " "
        lblIso.text = " ISO: " + (data.iso as String?)! + " "
        lblApeture.text = " Aperture: " + (data.aperture as String?)! + " "
        lblName.text = (data.uname as String?)!
        var date = (data.uploaddate as String?)!
        date = date.replacingOccurrences(of: "+0000", with: "")
        lblDate.text = date
        let url = URL(string: data.imgurl as String)
        ivPhoto.kf.setImage(with: url)
    }
    
    // download
    @IBAction func downloadPressed(_ sender: Any) {
        savePhoto()
    }
    
    // save photo
    func savePhoto() {
        if self.ivPhoto.image == nil
        {
            return
        }
        let p = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: managedObjectContext) as? Photo
        let tmpImage = self.ivPhoto.image! as UIImage
        let imgData:NSData?
        if UIImagePNGRepresentation(tmpImage) == nil {
            imgData=UIImageJPEGRepresentation(tmpImage, 1.0) as NSData?
        }
        else {
            imgData=UIImagePNGRepresentation(tmpImage) as NSData?
        }
        p?.img = imgData
        p?.uid = String(data.uid)
        p?.uname = String(data.uname)
        p?.uploaddate = String(data.uploaddate)
        p?.aperture = String(data.aperture)
        p?.shutter = String(data.shutter)
        p?.iso = String(data.iso)
        p?.desc = String(data.desc)
        p?.postid = String(data.postid)
        p?.uid = String(data.uid)
        p?.tags = data.tags
        p?.device = String(data.device)
        saveRecords()
    }
    
    // save records to database
    func saveRecords()
    {
        do {
            try self.managedObjectContext.save()
            delegate?.photoSaved()
        } catch {
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
