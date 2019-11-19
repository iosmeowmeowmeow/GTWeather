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
    var baseURL: URL!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()

        baseURL = URL(string: "http://openweathermap.fake.org/api")!
        mockSession = MockURLSession()
        sut = GTWeatherClient(baseURL: baseURL, session: mockSession)
    }

    override func tearDown() {
        baseURL = nil
        mockSession = nil
        sut = nil

        super.tearDown()
    }

    func test_init_sets_baseURL() {
      XCTAssertEqual(sut.baseURL, baseURL)
    }

    func test_init_sets_session() {
      XCTAssertEqual(sut.session, mockSession)
    }
}

typealias NetworkResponse = (Data?, URLResponse?, Error?) -> Void

class MockURLSessionDataTask: URLSessionDataTask {
    var calledResume = false
    var completionHandler: NetworkResponse
    var url: URL

    init(completionHandler: @escaping NetworkResponse, url: URL) {
        self.completionHandler = completionHandler
        self.url = url
    }

    override func resume() {
        calledResume = true
    }
}

class MockURLSession: URLSession {
    override func dataTask(with url: URL, completionHandler: @escaping NetworkResponse) -> URLSessionDataTask {
        return MockURLSessionDataTask(completionHandler: completionHandler, url: url)
  }
}
