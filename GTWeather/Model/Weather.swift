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
        case location = "coord"
        case locationName = "name"
        
        case details = "weather"

        case main
        case wind
    }

    enum DetailsKey: String, CodingKey {
        case description
    }
    
    var id: Int
    var location: Location
    var locationName: String

    private var _details: [Details]

    var description: String {
        return _details.first?.description ?? ""
    }

    var mainData: MainData
    var wind: Wind

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        location = try container.decode(Location.self, forKey: .location)
        locationName = try container.decode(String.self, forKey: .locationName)
        
        _details = try container.decode([Details].self, forKey: .details)
        
        mainData = try container.decode(MainData.self, forKey: .main)
        wind = try container.decode(Wind.self, forKey: .wind)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(location, forKey: .location)
        try container.encode(locationName, forKey: .locationName)
        try container.encode(_details, forKey: .details)
        try container.encode(mainData, forKey: .main)
        try container.encode(wind, forKey: .wind)
    }

    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.id == rhs.id
    }
}

