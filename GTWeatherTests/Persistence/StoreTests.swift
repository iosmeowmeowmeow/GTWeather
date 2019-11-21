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
    let mockSuiteName = "PersistenceTests.Store"
    
    var sut: Store!

    override func setUp() {
        super.setUp()
        
        sut = Store(persistence: UserDefaults(suiteName: mockSuiteName)!)
    }

    override func tearDown() {
        UserDefaults().removePersistentDomain(forName: mockSuiteName)
        sut = nil
        
        super.tearDown()
    }

}
