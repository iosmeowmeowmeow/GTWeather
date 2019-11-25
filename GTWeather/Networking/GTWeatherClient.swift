//
//  GTWeatherClient.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 19/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import Foundation

typealias WeatherResponse = (Weather?, Error?) -> ()

protocol WeatherClient {
    func weatherForCity(_ city: String, completion: @escaping WeatherResponse) -> URLSessionDataTask?
    func weatherForZIPCode(_ code: String, completion: @escaping WeatherResponse) -> URLSessionDataTask?
    func weatherForCoordinates(latitude: Double, longitude: Double, completion: @escaping WeatherResponse) -> URLSessionDataTask?
}

class GTWeatherClient {
    let baseURLAddr: String
    let session: URLSession

    init(baseURLAddr: String = "http://api.openweathermap.org/data/2.5/weather", session: URLSession = .shared) {
      self.baseURLAddr = baseURLAddr
      self.session = session
    }
}

extension GTWeatherClient: WeatherClient {
    func weatherForCity(_ city: String, completion: @escaping WeatherResponse) -> URLSessionDataTask? {
        guard let countryCode = Bundle.main.object(forInfoDictionaryKey: "Country") as? String else { return nil }

        guard let url = requestURLWithParams(["q": "\(city),\(countryCode)"]) else { return nil }
        
        return startDataTaskForURL(url, completion: completion)
    }
    
    func weatherForZIPCode(_ code: String, completion: @escaping WeatherResponse) -> URLSessionDataTask? {
        guard let countryCode = Bundle.main.object(forInfoDictionaryKey: "Country") as? String else { return nil }

        guard let url = requestURLWithParams(["zip": "\(code),\(countryCode)"]) else { return nil }
        
        return startDataTaskForURL(url, completion: completion)
    }
    
    func weatherForCoordinates(latitude: Double, longitude: Double, completion: @escaping WeatherResponse) -> URLSessionDataTask? {
        guard let url = requestURLWithParams(["lat": "\(latitude)", "lon": "\(longitude)"]) else { return nil }
        
        return startDataTaskForURL(url, completion: completion)
    }
    
    private func startDataTaskForURL(_ url: URL, completion: @escaping WeatherResponse) -> URLSessionDataTask? {
        let task = session.dataTask(with: url) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                error == nil,
                let data = data
            else {
                completion(nil, error)
                return
            }
  
            let decoder = JSONDecoder()
            do {
                let weather = try decoder.decode(Weather.self, from: data)
                
                completion(weather, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
        return task
    }
    
    private func requestURLWithParams(_ params: [String: String]) -> URL? {
        var queryItems = [URLQueryItem(name: "appid", value: "95d190a434083879a6398aafd54d9e73")]
        
        params.forEach { queryItems.append(URLQueryItem(name: $0.key, value: $0.value)) }
        
        var urlComponents = URLComponents(string: baseURLAddr)
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
    }
}
