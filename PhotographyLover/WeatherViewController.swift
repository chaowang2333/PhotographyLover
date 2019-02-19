//
//  WeatherViewController.swift
//  PhotographyLover
//
//  Created by wc on 6/05/2017.
//  Copyright © 2017 ChaoWang27548848. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, PickLocationDelegate {
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var lblSunset: UILabel!
    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblWeather: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    var currentLocation : CLLocationCoordinate2D?
    var lat : Double?
    var lon : Double?
    var weather: String?
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        currentLocation = locValue
        if lat == nil
        {
            lat = locValue.latitude
            lon = locValue.longitude
            requestWeather()
        }
    }
    
    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestWeather()
    }
    
    // pick location button pressed
    @IBAction func pickPressed(_ sender: Any) {
        let vc = MapViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // use current location button pressed
    @IBAction func currentPressed(_ sender: Any) {
        lat = (currentLocation?.latitude)!
        lon = (currentLocation?.longitude)!
        requestWeather()
    }
    
    // location picked
    func pickLocation(location: CLLocationCoordinate2D){
        lat = location.latitude
        lon = location.longitude
        requestWeather()
    }
    
    // request weather info
    func requestWeather() {
        if lat == nil
        {
            return
        }
        let url = URL(string: CONST.WEATHER_URL + "?lat=" + String(lat!) + "&lon=" + String(lon!) + "&appid=" + CONST.OPEN_WEATHER_KEY + "&units=metric")
        
        DispatchQueue.global(qos: .userInitiated).async {
            let task = URLSession.shared.dataTask(with: url!)
            {
                data, response, error in
                if data == nil
                {
                    DispatchQueue.main.async(execute: {
                        self.showFailMessage(view:self.view, message:"Network Failed!")
                        })
                    return
                }
                let json = JSON(data: data!)
                let sunrise = json["sys"]["sunrise"].doubleValue
                // change to date
                var timeInterval:TimeInterval = TimeInterval(sunrise)
                let date = NSDate(timeIntervalSince1970: timeInterval)
                // date format
                let dformatter = DateFormatter()
                dformatter.dateFormat = "HH:mm:ss"
    
                let sunset = json["sys"]["sunset"].doubleValue
                // change to date
                timeInterval = TimeInterval(sunset)
                let dateSunset = NSDate(timeIntervalSince1970: timeInterval)
                
                // name
                let name = json["name"].stringValue
                // weather
                let weather = json["weather"][0]["main"].stringValue
              
                DispatchQueue.main.async(execute: {
                    self.lblSunrise.text = dformatter.string(from: date as Date)
                    self.lblSunset.text = dformatter.string(from: dateSunset as Date)
                    self.lblLocation.text = name
                    self.lblWeather.text = weather
                })
            }
            task.resume()
        }
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
