//
//  Forecast.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 19/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import Foundation

struct Forecast: Decodable {
    enum CodingKeys: String, CodingKey {
        case main
        case details = "weather"
    }

    let main: MainData
    let details: [Details]
}
