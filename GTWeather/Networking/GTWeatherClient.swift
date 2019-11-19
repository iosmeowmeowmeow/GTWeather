//
//  GTWeatherClient.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 19/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import Foundation

class GTWeatherClient {
    let baseURL: URL
    let session: URLSession

    init(baseURL: URL, session: URLSession) {
      self.baseURL = baseURL
      self.session = session
    }
}
