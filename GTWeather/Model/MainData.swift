//
//  MainData.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 22/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import Foundation

struct MainData: Codable {
    enum CodingKeys: String, CodingKey {
        case temperatureAverage = "temp"
        case pressure
        case humidity
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
    }
    
    var pressure: Double
    var humidity: Double

    var temperatureAverage: Double
    var temperatureMin: Double
    var temperatureMax: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        temperatureAverage = try container.decode(Double.self, forKey: .temperatureAverage)
        temperatureMin = try container.decode(Double.self, forKey: .temperatureMin)
        temperatureMax = try container.decode(Double.self, forKey: .temperatureMax)
        pressure = try container.decode(Double.self, forKey: .pressure)
        humidity = try container.decode(Double.self, forKey: .humidity)
    }
}
