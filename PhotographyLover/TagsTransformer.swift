//
//  TagsTransformer.swift
//  PhotographyLover
//
//  Created by wc on 9/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit

public class TagsTransformer: ValueTransformer {
    
    func transformedValueClass()-> Swift.AnyClass {
        return NSArray.self
    }
    
    public override func transformedValue(_ value: Any?) -> Any? {
        return NSKeyedArchiver.archivedData(withRootObject: value!)
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        return NSKeyedUnarchiver.unarchiveObject(with: value! as! Data)
    }
    
    func allowsReverseTransformation() -> Bool {
        return true
    }
}
