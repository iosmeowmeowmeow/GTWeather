//
//  Store.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 22/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import Foundation

protocol Persistence {
    func save(weather: Weather)
    func storedWeather() -> Weather?
}

class Store {
    private let persistence: Persistence
    
    init(persistence: Persistence = UserDefaults.standard) {
        self.persistence = persistence
    }
    
    func save(weather: Weather) {
        persistence.save(weather: weather)
    }
    
    func storedWeather() -> Weather? {
        return persistence.storedWeather()
    }
}

extension UserDefaults: Persistence {
    static var weatherKey: String { "Persistence.Weather" }
    
    func save(weather: Weather) {
        guard let encodedWeather = try? JSONEncoder().encode(weather) else { return }
        
        set(encodedWeather, forKey: UserDefaults.weatherKey)
    }
    
    func storedWeather() -> Weather? {
        guard let storedData = data(forKey: UserDefaults.weatherKey) else { return nil }

        return try? JSONDecoder().decode(Weather.self, from: storedData)
    }
}
