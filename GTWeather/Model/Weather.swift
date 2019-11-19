//
//  Weather.swift
//  GumWeather
//
//  Created by Emmanuel Tugado on 19/11/19.
//  Copyright © 2019 Douugh. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    enum CodingKeys: String, CodingKey {
        case weatherDetails = "weather"

        case main
        case wind

        case locationName = "name"
    }

    enum WeatherDetailsKeys: String, CodingKey {
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

    private var _details: [WeatherDetails]

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

        _details = try container.decode([WeatherDetails].self, forKey: .weatherDetails)
    }
}
