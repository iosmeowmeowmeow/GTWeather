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
}

class Store {
    private let persistence: Persistence
    
    init(persistence: Persistence) {
        self.persistence = persistence
    }
}

extension UserDefaults: Persistence {
    func save(weather: Weather) {
        let encoder = JSONEncoder()
        
        guard let encodedWeather = try? encoder.encode(weather) else { return }
        
        
    }
}
