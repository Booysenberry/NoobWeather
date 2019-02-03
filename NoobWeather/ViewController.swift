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
    var currentTemp: Double?
    var minTemp: Double?
    var maxTemp: Double?
    var cityName: String?
    var id: Int?
    var weatherDescription: String?
    
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
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
        displayCurrentWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let userlocation:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = userlocation.latitude
        longitude = userlocation.longitude
        getWeatherData()
        displayCurrentWeather()
    }
    
    func displayWeatherImage() {
        if let id = id {
            
            switch (id) {
            case 200...299:
                weatherIcon.image = UIImage(named: "thunderstorm")
            case 300...399:
                weatherIcon.image = UIImage(named: "showerRain")
            case 500...599:
                weatherIcon.image = UIImage(named: "Rain")
            case 600...699:
                weatherIcon.image = UIImage(named: "snow")
            case 700...799:
                weatherIcon.image = UIImage(named: "showerRain")
            case 800:
                weatherIcon.image = UIImage(named: "clearSky")
            case 801...805:
                weatherIcon.image = UIImage(named: "scatteredClouds")
            default:
                break
            }
        }
    }
    
    func displayCurrentWeather() {
        if let todaysCurrentTemp = currentTemp {
            if let todaysMinTemp = minTemp {
                if let todaysMaxTemp = maxTemp {
                    if let city = cityName {
                        if let currentWeatherDesc = weatherDescription {
                            cityLabel.text = "\(city)"
                            currentTempLabel.text = "\(todaysCurrentTemp)"
                            tempRange.text = "↓\(todaysMinTemp) - ↑\(todaysMaxTemp)"
                            weatherDescriptionLabel.text = "\(currentWeatherDesc)"
                            displayWeatherImage()
                        }
                    }
                }
            }
        }
    }
    
    func getWeatherData() {
        
        // Setup URLSession configuration
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // Create URL
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=5c1013a7da44573668f4d581562109dd&units=metric")!
        
        // Create data task
        let task = session.dataTask(with: url) { data, response, error in
            
            // Check for errors
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            // Check that data has been returned
            guard let content = data else {
                print("No data")
                return
            }
            
            // Decode data
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let currentWeatherData = try decoder.decode(WeatherData.self, from: content)
                print(currentWeatherData)
                self.currentTemp = currentWeatherData.main.temp
                self.maxTemp = currentWeatherData.main.tempMax
                self.minTemp = currentWeatherData.main.tempMin
                self.cityName = currentWeatherData.name
                // Access description (first item in weather array)
                self.weatherDescription = currentWeatherData.weather.first?.description
                // Access id (second item in weather array)
                self.id = currentWeatherData.weather.last?.id
    
            } catch let err {
                print("Err", err)
            }
        }
        task.resume()
    }
}

