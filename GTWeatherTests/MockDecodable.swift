//
//  MockDecodable.swift
//  GumWeatherTests
//
//  Created by Emmanuel Tugado on 19/11/19.
//  Copyright © 2019 Douugh. All rights reserved.
//

import Foundation
import XCTest

protocol MockDecodable: class {
    associatedtype T: Decodable

    var dictionary: [String: Any]! { get set }

    var sut: T! { get set }
}

extension MockDecodable {
    func createSUTAndDictionaryFromJSONWith(
        fileName: String = "\(T.self)",
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let decoder = JSONDecoder()

        let data = try Data.dataFromJSON(fileName: fileName, file: file, line: line)
        dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

        sut = try decoder.decode(T.self, from: data)
  }
}

extension Data {
    public static func dataFromJSON(
        fileName: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Data {
        let bundle = Bundle(for: TestClass.self)
        let url = try XCTUnwrap(bundle.url(forResource: fileName, withExtension: "json"), "Missing file \(file).json", file: file, line: line)

        return try Data(contentsOf: url)
    }
}

private class TestClass { }
