//
//  DownloadCell.swift
//  PhotographyLover
//
//  Created by wc on 12/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit

protocol DeleteDelegate {
    // delete 
    func deletePhoto(rowIndex: Int)
}

class DownloadCell: UITableViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblIso: UILabel!
    @IBOutlet weak var lblApeture: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblShutter: UILabel!
    @IBOutlet weak var ivPhoto: UIImageView!
    var delegate : DeleteDelegate?
    var data : Photo?
    var rowIndex : Int?
    
    // init
    override func awakeFromNib() {
        super.awakeFromNib()
        // layout out
        lblShutter.layer.cornerRadius = 5
        lblShutter.layer.masksToBounds = true
        lblApeture.layer.cornerRadius = 5
        lblApeture.layer.masksToBounds = true
        lblIso.layer.cornerRadius = 5
        lblIso.layer.masksToBounds = true
    }
    
    // set photo data
    func setData(data: Photo) {
        self.data = data
        lblShutter.text = " Shutter: " + (data.shutter as String?)! + " "
        lblIso.text = " ISO: " + (data.iso as String?)! + " "
        lblApeture.text = " Aperture: " + (data.aperture as String?)! + " "
        lblName.text = (data.uname as String?)!
        var date = (data.uploaddate as String?)!
        date = date.replacingOccurrences(of: "+0000", with: "")
        lblDate.text = date
        ivPhoto.image = UIImage(data: data.img as! Data)
    }

    // delete photo
    @IBAction func deletePressed(_ sender: Any) {
        delegate?.deletePhoto(rowIndex: rowIndex!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
