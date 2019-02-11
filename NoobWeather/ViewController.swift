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
    var currentTemp: Float?
    var cityName: String?
    var id: Int?
    var weatherDescription: String?
    var userLocated = false
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func animateImages() {
        let diceImages: [UIImage] = [
            UIImage(named: "clearSky.png")!,UIImage(named: "scatteredClouds.png")!,UIImage(named: "Rain.png")!, UIImage(named: "fewClouds.png")!]
        
        self.weatherIcon.animationImages = diceImages;
        self.weatherIcon.animationDuration = 1.0
        self.weatherIcon.startAnimating()
        cityLabel.text = ""
        currentTempLabel.text = ""
    }
    
    
    @IBAction func refreshButton(_ sender: Any) {
        getWeatherData()
        displayCurrentWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocated = true
        locationManager.stopUpdatingLocation()
        let userlocation:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = userlocation.latitude
        longitude = userlocation.longitude
        }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
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
            if let city = cityName {
                if let currentWeatherDesc = weatherDescription {
                    cityLabel.text = "\(city)"
                    currentTempLabel.text = "\(todaysCurrentTemp.rounded().formatted)°"
                    weatherDescriptionLabel.text = "\(currentWeatherDesc)".capitalizingFirstLetter()
                    displayWeatherImage()
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
                self.currentTemp = currentWeatherData.main.temp
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


