//
//  Weather.swift
//  GumWeather
//
//  Created by Emmanuel Tugado on 19/11/19.
//  Copyright © 2019 Douugh. All rights reserved.
//

import Foundation

struct Weather: Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id
        case forecastList = "list"
        case city
    }

    let id: Int
    let forecastList: [Forecast]
    let city: City

    var locationName: String { return city.name }
    
    private var main: MainData? {
        return forecastList.first?.main
    }
    
    private var details: Details? {
        return forecastList.first?.details.first
    }

    var tempAve: Double {
        return main?.temperatureAverage ?? 0.0
    }
    var tempMin: Double {
        return main?.temperatureMin ?? 0.0
    }
    var tempMax: Double {
        return main?.temperatureMax ?? 0.0
    }
    var pressure: Double {
        return main?.pressure ?? 0.0
    }
    var humidity: Double {
        return main?.humidity ?? 0.0
    }

    var description: String {
        return details?.description ?? ""
    }
    
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.id == rhs.id
    }
}

