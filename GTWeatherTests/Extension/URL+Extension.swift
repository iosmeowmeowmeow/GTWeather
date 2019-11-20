//
//  URL+Extension.swift
//  GTWeatherTests
//
//  Created by Emmanuel Tugado on 20/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import Foundation

extension URL {
    subscript(param: String) -> String? {
        guard let queryItems = URLComponents(string: self.absoluteString)?.queryItems else { return nil }
        
        return queryItems.first(where: { $0.name.caseInsensitiveCompare(param) == .orderedSame  })?.value
    }
}
