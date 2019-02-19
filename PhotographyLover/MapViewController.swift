//
//  MapViewController.swift
//  PhotographyLover
//
//  Created by wc on 22/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import MapKit

protocol PickLocationDelegate {
   func pickLocation(location: CLLocationCoordinate2D)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var delegate : PickLocationDelegate?
    var location : CLLocationCoordinate2D?
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pick Location"
        // tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnMap))
        let tapDouble=UITapGestureRecognizer(target:self,action:#selector(doubleTap))
        tapDouble.numberOfTapsRequired = 2
        tapDouble.numberOfTouchesRequired = 1
        // single tap need double tap fail
        tap.require(toFail: tapDouble)
        self.mapView.addGestureRecognizer(tap)
        self.mapView.addGestureRecognizer(tapDouble)
        
        // confirm button
        let btnNext = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(confirmPressed))
        self.navigationItem.rightBarButtonItem = btnNext
    }
    
    // confirm button pressed
    func confirmPressed() {
        if self.location == nil
        {
            self.showFailMessage(view: self.view, message: "Have not pick a location!")
            return
        }
        // send back location info
        delegate?.pickLocation(location: self.location!)
        self.navigationController?.popViewController(animated: true)
    }
    
    // double tap
    func doubleTap() {
    }
    
    // tap on map, add annotation
    func tapOnMap(tap: UITapGestureRecognizer) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        let loc = self.mapView.convert(tap.location(ofTouch: 0, in: self.mapView), toCoordinateFrom: self.mapView)
        self.location = loc
        let locAn: LocationAnnotation = LocationAnnotation(newTitle: "Picked Location",newSubtitle: String(loc.latitude) + "," + String(loc.longitude), lat: loc.latitude, long: loc.longitude)
        
        self.mapView.addAnnotation(locAn)
        self.mapView.selectAnnotation(locAn, animated: false)
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
