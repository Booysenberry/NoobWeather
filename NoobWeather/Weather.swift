//
//  Location.swift
//  NoobWeather
//
//  Created by Brad Booysen on 25/01/19.
//  Copyright © 2019 Brad Booysen. All rights reserved.
//

import Foundation


struct WeatherData: Codable {
    let main: Main
    let weather: [WeatherConditions]
}

struct Main: Codable {
    let temp: Double
    let tempMax: Double
    let tempMin: Double
}

struct WeatherConditions: Codable {
    let description: String
}

