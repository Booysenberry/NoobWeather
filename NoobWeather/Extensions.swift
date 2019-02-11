//
//  Extensions.swift
//  NoobWeather
//
//  Created by Brad Booysen on 6/02/19.
//  Copyright © 2019 Brad Booysen. All rights reserved.
//

import Foundation

// Capitalise first letter of String
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension Float {
    var formatted: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
