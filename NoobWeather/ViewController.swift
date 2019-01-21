//
//  ViewController.swift
//  NoobWeather
//
//  Created by Brad Booysen on 21/01/19.
//  Copyright © 2019 Brad Booysen. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var latitude = 0.0
    var longitude = 0.0

    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempRange: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }

    }

    @IBAction func refreshButton(_ sender: Any) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let userlocation:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = userlocation.latitude
        longitude = userlocation.longitude
        print(latitude)
        print(longitude)
    }
    
}

