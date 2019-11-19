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
    var session: MockURLSession!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
