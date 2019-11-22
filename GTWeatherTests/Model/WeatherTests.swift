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

    var mainDictionary: [String: Any]!
    var windDictionary: [String: Any]!

    override func setUp() {
        super.setUp()

        try! createSUTAndDictionaryFromJSONWith(fileName: "data")
        mainDictionary = dictionary["main"] as? [String: Any] ?? [:]
        windDictionary = dictionary["wind"] as? [String: Any] ?? [:]
    }

    override func tearDown() {
        sut = nil
        dictionary = nil
        mainDictionary = nil
        windDictionary = nil

        super.tearDown()
    }

    func test_conformsTo_Decodable() {
        XCTAssertTrue((sut as Any) is Decodable)
    }

    func test_decodable_sets_description() {
        guard let weather = dictionary["weather"] as? [[String: Any]] else { return }
        XCTAssertEqual(sut.description, weather[0]["description"] as? String)
    }

    func test_decodable_sets_pressure() {
        XCTAssertEqual(sut.mainData.pressure, mainDictionary["pressure"] as? Double)
    }

    func test_decodable_sets_humidity() {
        XCTAssertEqual(sut.mainData.humidity, mainDictionary["humidity"] as? Double)
    }

    func test_decodable_sets_temperatureAverage() {
        XCTAssertEqual(sut.mainData.temperatureAverage, mainDictionary["temp"] as? Double)
    }

    func test_decodable_sets_temperatureMin() {
        XCTAssertEqual(sut.mainData.temperatureMin, mainDictionary["temp_min"] as? Double)
    }

    func test_decodable_sets_temperatureMax() {
        XCTAssertEqual(sut.mainData.temperatureMax, mainDictionary["temp_max"] as? Double)
    }

    func test_decodable_sets_windSpeed() {
        XCTAssertEqual(sut.wind.windSpeed, windDictionary["speed"] as? Double)
    }

    func test_decodable_sets_windDirection() {
        XCTAssertEqual(sut.wind.windDirection, windDictionary["deg"] as? Double)
    }

    func test_decodable_setsLocationName() {
        guard let locName = dictionary["name"] as? String else { return }

        XCTAssertEqual(sut.locationName, locName)
    }
}

