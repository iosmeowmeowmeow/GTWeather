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
    
    func save(location: String)
    func storedLocations() -> [String]
    func clearStoredLocations()
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
    
    func save(location: String) {
        persistence.save(location: location)
    }
    
    func storedLocations() -> [String] {
        return persistence.storedLocations()
    }
    
    func clearStoredLocations() {
        persistence.clearStoredLocations()
    }
}

extension UserDefaults: Persistence {
    static var weatherKey: String { "Persistence.Weather" }
    static var locationsKey: String { "Persistence.Locations" }
    
    func save(weather: Weather) {
        guard let encodedWeather = try? JSONEncoder().encode(weather) else { return }
        
        set(encodedWeather, forKey: UserDefaults.weatherKey)
    }
    
    func storedWeather() -> Weather? {
        guard let storedData = data(forKey: UserDefaults.weatherKey) else { return nil }

        return try? JSONDecoder().decode(Weather.self, from: storedData)
    }
    
    func save(location: String) {
        let locations = (array(forKey: UserDefaults.locationsKey) as? [String]) ?? []
        var uniqueLocations = Array(Set(locations))
        uniqueLocations.append(location)

        set(uniqueLocations, forKey: UserDefaults.locationsKey)
    }
    
    func storedLocations() -> [String] {
        return (array(forKey: UserDefaults.locationsKey) as? [String]) ?? []
    }
    
    func clearStoredLocations() {
        set(nil, forKey: UserDefaults.locationsKey)
    }
}
