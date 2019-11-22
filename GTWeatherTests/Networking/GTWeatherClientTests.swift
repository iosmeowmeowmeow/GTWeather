//
//  GTWeatherClientTests.swift
//  GTWeatherTests
//
//  Created by Emmanuel Tugado on 19/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

@testable import GTWeather
import XCTest

class GTWeatherClientTests: XCTestCase {
    var sut: GTWeatherClient!
    var baseURLAddr: String!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()

        baseURLAddr = "http://openweathermap.fake.org/api"
        
        mockSession = MockURLSession()
        sut = GTWeatherClient(baseURLAddr: baseURLAddr, session: mockSession)
    }

    override func tearDown() {
        baseURLAddr = nil
        mockSession = nil
        sut = nil

        super.tearDown()
    }

    func test_init_sets_baseURL() {
        XCTAssertEqual(sut.baseURLAddr, baseURLAddr)
    }

    func test_init_sets_session() {
        XCTAssertEqual(sut.session, mockSession)
    }

    func test_weatherForCity_containsCity() {
        let mockTask = sut.weatherForCity("sydney") { _, _ in } as! MockURLSessionDataTask
        XCTAssertEqual(mockTask.url["q"], "sydney")
    }
    
    func test_weatherForZIPCode_containsZIPCode() {
        let mockTask = sut.weatherForZIPCode("2345") { _, _ in } as! MockURLSessionDataTask
        XCTAssertEqual(mockTask.url["zip"], "2345,au")
    }
    
    func test_weatherForCoordinates_containsCoordinates() {
        let mockTask = sut.weatherForCoordinates(latitude: 123.67, longitude: 345.1) { _, _ in } as! MockURLSessionDataTask
        
        XCTAssertEqual(mockTask.url["lat"], "123.67")
        XCTAssertEqual(mockTask.url["lon"], "345.1")
    }
    
    private func generateNetworkResponseWithStatusCode(_ statusCode: Int = 200, dataTask: MockURLSessionDataTask) throws {
        let data = try Data.dataFromJSON(fileName: "data")
        
        let response = HTTPURLResponse(
            url: URL(string: baseURLAddr)!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
        
        dataTask.completionHandler(data, response, nil)
    }

    func test_weatherForCity_givenValidJSON_callsCompletionWithWeather() throws {
        var calledCompletion = false
        var receivedWeather: Weather? = nil
        var receivedError: Error? = nil
        
        let mockTask = sut.weatherForCity("sydney") { weather, error in
            calledCompletion = true
            receivedWeather = weather
            receivedError = error as NSError?
        } as! MockURLSessionDataTask

        try generateNetworkResponseWithStatusCode(dataTask: mockTask)
        
        let result = (calledCompletion, receivedWeather, receivedError)

        XCTAssertTrue(result.0)
        XCTAssertEqual(result.1, receivedWeather)
        XCTAssertNil(result.2)
    }
    
    func test_weatherForZIPCode_givenValidJSON_callsCompletionWithWeather() throws {
        var calledCompletion = false
        var receivedWeather: Weather? = nil
        var receivedError: Error? = nil
        
        let mockTask = sut.weatherForZIPCode("2345") { weather, error in
            calledCompletion = true
            receivedWeather = weather
            receivedError = error as NSError?
        } as! MockURLSessionDataTask

        try generateNetworkResponseWithStatusCode(dataTask: mockTask)
        
        let result = (calledCompletion, receivedWeather, receivedError)

        XCTAssertTrue(result.0)
        XCTAssertEqual(result.1, receivedWeather)
        XCTAssertNil(result.2)
    }
    
    func test_weatherForCoordinates_givenValidJSON_callsCompletionWithWeather() throws {
        var calledCompletion = false
        var receivedWeather: Weather? = nil
        var receivedError: Error? = nil
        
        let mockTask = sut.weatherForCoordinates(latitude: 123.45, longitude: 99.8) { weather, error in
            calledCompletion = true
            receivedWeather = weather
            receivedError = error as NSError?
        } as! MockURLSessionDataTask

        try generateNetworkResponseWithStatusCode(dataTask: mockTask)
        
        let result = (calledCompletion, receivedWeather, receivedError)

        XCTAssertTrue(result.0)
        XCTAssertEqual(result.1, receivedWeather)
        XCTAssertNil(result.2)
    }
    
    func test_weatherForCity_givenNon500StatusCode_callsCompletion() throws {
        var calledCompletion = false
        var receivedWeather: Weather? = nil
        var receivedError: Error? = nil
        
        let mockTask = sut.weatherForCity("sydney") { weather, error in
            calledCompletion = true
            receivedWeather = weather
            receivedError = error as NSError?
        } as! MockURLSessionDataTask

        try generateNetworkResponseWithStatusCode(500, dataTask: mockTask)
        
        let result = (calledCompletion, receivedWeather, receivedError)

        XCTAssertTrue(result.0)
        XCTAssertNil(result.1)
        XCTAssertNil(result.2)
    }
    
    func test_weatherForZIPCode_givenNon500StatusCode_callsCompletion() throws {
        var calledCompletion = false
        var receivedWeather: Weather? = nil
        var receivedError: Error? = nil
        
        let mockTask = sut.weatherForZIPCode("2345") { weather, error in
            calledCompletion = true
            receivedWeather = weather
            receivedError = error as NSError?
        } as! MockURLSessionDataTask

        try generateNetworkResponseWithStatusCode(500, dataTask: mockTask)
        
        let result = (calledCompletion, receivedWeather, receivedError)

        XCTAssertTrue(result.0)
        XCTAssertNil(result.1)
        XCTAssertNil(result.2)
    }
    
    func test_weatherForCoordinates_givenNon500StatusCode_callsCompletion() throws {
        var calledCompletion = false
        var receivedWeather: Weather? = nil
        var receivedError: Error? = nil
        
        let mockTask = sut.weatherForCoordinates(latitude: 123.45, longitude: 99.8) { weather, error in
            calledCompletion = true
            receivedWeather = weather
            receivedError = error as NSError?
        } as! MockURLSessionDataTask

        try generateNetworkResponseWithStatusCode(500, dataTask: mockTask)
        
        let result = (calledCompletion, receivedWeather, receivedError)

        XCTAssertTrue(result.0)
        XCTAssertNil(result.1)
        XCTAssertNil(result.2)
    }
}

typealias NetworkResponse = (Data?, URLResponse?, Error?) -> Void

class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: NetworkResponse
    var url: URL

    init(completionHandler: @escaping NetworkResponse, url: URL) {
        self.completionHandler = completionHandler
        self.url = url
    }

    override func resume() {}
}

class MockURLSession: URLSession {
    override func dataTask(with url: URL, completionHandler: @escaping NetworkResponse) -> URLSessionDataTask {
        return MockURLSessionDataTask(completionHandler: completionHandler, url: url)
  }
}
