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
        case forecastList = "list"
        case city
    }

    let forecastList: [Forecast]
    let city: City
}
