//
//  WeatherTests.swift
//  GumWeatherTests
//
//  Created by Emmanuel Tugado on 19/11/19.
//  Copyright © 2019 Douugh. All rights reserved.
//

@testable import GTWeather
import XCTest

class WeatherTests: XCTestCase, MockDecodable {
    var sut: Weather!
    var dictionary: [String: Any]!

    var cityDictionary: [String: Any]!
    var mainDictionary: [String: Any]!
    var weatherDictionary: [String: Any]!

    override func setUp() {
        super.setUp()

        try! createSUTAndDictionaryFromJSONWith(fileName: "data")

        cityDictionary = dictionary["city"] as? [String: Any] ?? [:]

        mainDictionary = (dictionary["list"] as? [[String: Any]])?[0]["main"] as? [String: Any] ?? [:]
        let weatherArray = (dictionary["list"] as! [[String: Any]])[0]["weather"] as? [[String: Any]] ?? []
        weatherDictionary = weatherArray[0]
    }

    override func tearDown() {
        sut = nil
        dictionary = nil

        cityDictionary = nil

        mainDictionary = nil
        weatherDictionary = nil

        super.tearDown()
    }

    func test_conformsTo_Decodable() {
        XCTAssertTrue((sut as Any) is Decodable)
    }
    
    func test_decodable_setsLocationName() {
        guard let locName = cityDictionary["name"] as? String else { return }

        XCTAssertEqual(sut.locationName, locName)
    }
    
    func test_decodable_sets_pressure() {
        XCTAssertEqual(sut.pressure, mainDictionary["pressure"] as? Double)
    }
    
    func test_decodable_sets_humidity() {
        XCTAssertEqual(sut.humidity, mainDictionary["humidity"] as? Double)
    }

    func test_decodable_sets_temperatureAverage() {
        XCTAssertEqual(sut.tempAve, mainDictionary["temp"] as? Double)
    }

    func test_decodable_sets_temperatureMin() {
        XCTAssertEqual(sut.tempMin, mainDictionary["temp_min"] as? Double)
    }
    
    func test_decodable_sets_temperatureMax() {
        XCTAssertEqual(sut.tempMax, mainDictionary["temp_max"] as? Double)
    }
    
    func test_decodable_sets_description() {
        XCTAssertEqual(sut.description, weatherDictionary["description"] as? String)
    }
}

