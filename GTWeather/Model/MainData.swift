//
//  MainData.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 19/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import Foundation

struct MainData: Decodable {
    enum CodingKeys: String, CodingKey {
        case pressure
        case humidity
        case temperatureAverage = "temp"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
    }

    let pressure: Double
    let humidity: Double

    let temperatureAverage: Double
    let temperatureMin: Double
    let temperatureMax: Double
}
