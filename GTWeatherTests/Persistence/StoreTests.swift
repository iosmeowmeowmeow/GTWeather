//
//  StoreTests.swift
//  GTWeatherTests
//
//  Created by Emmanuel Tugado on 22/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

@testable import GTWeather
import XCTest

class StoreTests: XCTestCase {
    lazy var weatherStub: Weather? = {
        guard let data = try? Data.dataFromJSON(fileName: "data") else { return nil }
        
        return try? JSONDecoder().decode(Weather.self, from: data)
    }()
    
    let mockSuiteName = "PersistenceTests.Store"
    var mockDefaults: UserDefaults!
    
    var sut: Store!

    override func setUp() {
        super.setUp()
        
        mockDefaults =  UserDefaults(suiteName: mockSuiteName)!
        sut = Store(persistence: mockDefaults)
    }

    override func tearDown() {
        UserDefaults().removePersistentDomain(forName: mockSuiteName)
        mockDefaults = nil
        sut = nil
        
        super.tearDown()
    }

    func test_saveWeather_storesWeather() {
        guard let weather = weatherStub else { return }
        
        sut.save(weather: weather)
        
        let data = mockDefaults.data(forKey: UserDefaults.weatherKey)!
        let dict = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        print(dict)
        
        guard let weatherData = mockDefaults.data(forKey: UserDefaults.weatherKey),
            let savedWeather = try? JSONDecoder().decode(Weather.self, from: weatherData)
        else {
            XCTFail("could not generate stubs")
            return
        }
        
        XCTAssertEqual(savedWeather, weather)
    }
    
    func test_storedWeather_returnsNothingInitially() {
        XCTAssertNil(sut.storedWeather())
    }
    
    func test_storedWeather_returnsStoredWeather() {
        guard let weather = weatherStub,
            let weatherData = try? JSONEncoder().encode(weather)
        else {
            XCTFail("could not generate stubs")
            return
        }
        
        mockDefaults.set(weatherData, forKey: UserDefaults.weatherKey)
        
        let storedWeather = sut.storedWeather()
        
        XCTAssertNotNil(storedWeather)
        XCTAssertEqual(storedWeather, weather)
    }
}

