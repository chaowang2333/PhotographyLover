//
//  MyTabBarButton.swift
//  PhotographyLover
//  (for future use)
//  Created by wc on 14/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit

class MyTabBarButton: UIButton {
    
    var item : UITabBarItem?

    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // set image to center
        self.imageView?.contentMode = UIViewContentMode.center
        // set title to center
        self.titleLabel?.textAlignment = NSTextAlignment.center
        // title font
        //self.titleLabel?.font = UIFont.systemFont(ofSize: 11.0)
        // remove highlight
        self.adjustsImageWhenHighlighted = false
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // get image frame
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageX : CGFloat = 0
        let imageY : CGFloat = 0
        let imageW : CGFloat = self.frame.width
        let imageH : CGFloat = self.frame.height
        return CGRect(x: imageX, y: imageY, width: imageW, height: imageH)
    }
    
    // set image
    func setItem(item: UITabBarItem) {
        self.item = item
        self.setImage(item.image, for: UIControlState.normal)
        self.setImage(item.selectedImage, for: UIControlState.selected)
    }
}
