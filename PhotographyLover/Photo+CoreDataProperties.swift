//
//  Photo+CoreDataProperties.swift
//  PhotographyLover
//
//  Created by wc on 12/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var aperture: String?
    @NSManaged public var desc: String?
    @NSManaged public var device: String?
    @NSManaged public var img: NSData?
    @NSManaged public var iso: String?
    @NSManaged public var postid: String?
    @NSManaged public var shutter: String?
    @NSManaged public var tags: NSArray?
    @NSManaged public var uid: String?
    @NSManaged public var uname: String?
    @NSManaged public var uploaddate: String?

}
