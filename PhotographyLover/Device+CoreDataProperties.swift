//
//  Device+CoreDataProperties.swift
//  PhotographyLover
//
//  Created by wc on 16/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import Foundation
import CoreData


extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device");
    }

    @NSManaged public var name: String?

}
