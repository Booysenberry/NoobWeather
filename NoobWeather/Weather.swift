//
//  Location.swift
//  NoobWeather
//
//  Created by Brad Booysen on 25/01/19.
//  Copyright © 2019 Brad Booysen. All rights reserved.
//

import Foundation


struct WeatherData: Codable {
    
    struct Main: Codable {
        var temp: Float
    }
    
    struct WeatherConditions: Codable {
        var description: String
        var id: Int
    }
    
    var main: Main
    var weather: [WeatherConditions]
    var name: String
    
}





