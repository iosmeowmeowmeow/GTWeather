//
//  Weather.swift
//  GumWeather
//
//  Created by Emmanuel Tugado on 19/11/19.
//  Copyright © 2019 Douugh. All rights reserved.
//

import Foundation

struct Weather: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id
        case locationName = "name"
        
        case details = "weather"

        case main
        case wind
    }

    enum DetailsKey: String, CodingKey {
        case description
    }

    enum MainKeys: String, CodingKey {
        case temperatureAverage = "temp"
        case pressure
        case humidity
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
    }

    enum WindKeys: String, CodingKey {
        case windSpeed = "speed"
        case windDirection = "deg"
    }

    var id: Int

    private var _details: [Details]

    var description: String {
        return _details.first?.description ?? ""
    }

    var pressure: Double
    var humidity: Double

    var temperatureAverage: Double
    var temperatureMin: Double
    var temperatureMax: Double

    var windSpeed: Double
    var windDirection: Double

    var locationName: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)

        locationName = try container.decode(String.self, forKey: .locationName)

        let mainContainer = try container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        temperatureAverage = try mainContainer.decode(Double.self, forKey: .temperatureAverage)
        temperatureMin = try mainContainer.decode(Double.self, forKey: .temperatureMin)
        temperatureMax = try mainContainer.decode(Double.self, forKey: .temperatureMax)
        pressure = try mainContainer.decode(Double.self, forKey: .pressure)
        humidity = try mainContainer.decode(Double.self, forKey: .humidity)

        let windContainer = try container.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        windSpeed = try windContainer.decode(Double.self, forKey: .windSpeed)
        windDirection = try windContainer.decode(Double.self, forKey: .windDirection)

        _details = try container.decode([Details].self, forKey: .details)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(locationName, forKey: .locationName)
        try container.encode(_details, forKey: .details)
        
        let mainDictionary: [String: Any] = [
            "temp": temperatureAverage,
            "temp_min": temperatureMin,
            "temp_max": temperatureMax,
            "pressure": pressure,
            "humidity": humidity
        ]
        let mainJSON = try JSONSerialization.data(withJSONObject: mainDictionary)
        try container.encode(mainJSON, forKey: .main)
        
        let windDictionary: [String: Any] = [
            "speed": windSpeed,
            "deg": windDirection
        ]
        let windJSON = try JSONSerialization.data(withJSONObject: windDictionary)
        try container.encode(windJSON, forKey: .wind)
    }

    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.id == rhs.id
    }
}

