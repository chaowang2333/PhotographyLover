//
//  LocationAnnotation.swift
//  Week 6 Base Code (from unit FIT4039 Monash University)
//
//  Created by Jason Haasz on 25/04/2016.
//  Copyright © 2016 Jason Haasz. All rights reserved.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    // init
    init( newTitle: String, newSubtitle: String, lat: Double, long: Double){
        title = newTitle
        subtitle = newSubtitle
        coordinate = CLLocationCoordinate2D()
        coordinate.latitude = lat
        coordinate.longitude = long
    }
}
