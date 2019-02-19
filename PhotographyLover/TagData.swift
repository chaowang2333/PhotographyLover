//
//  Tag.swift
//  PhotographyLover
//
//  Created by wc on 7/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit

class TagData: NSObject, NSCoding {
    
    var text: String?
    var top: CGFloat?
    var left: CGFloat?
    // 0: left, 1: right
    var orientation : Int?
    
    // encode
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(top, forKey: "top")
        aCoder.encode(left, forKey: "left")
        aCoder.encode(orientation, forKey: "orientation")
    }
    
    // init
    override init() {
        super.init()
    }
    
    // init
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "text") as? String
        top = aDecoder.decodeObject(forKey: "top") as? CGFloat
        left = aDecoder.decodeObject(forKey: "left") as? CGFloat
        orientation = aDecoder.decodeObject(forKey: "orientation") as? Int
    }

}
