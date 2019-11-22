//
//  Wind.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 22/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import Foundation

struct Wind: Codable {
    enum CodingKeys: String, CodingKey {
        case windSpeed = "speed"
        case windDirection = "deg"
    }
    
    var windSpeed: Double
    var windDirection: Double
}
