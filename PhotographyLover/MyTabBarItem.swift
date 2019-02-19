//
//  MyTabBarItem.swift
//  PhotographyLover
//
//  Created by wc on 6/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit

class MyTabBarItem: UIButton {

    // init
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // make the corner round
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
        setTitleColor(UIColor.darkGray, for: UIControlState.normal)
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    
    }
    

}
