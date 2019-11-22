//
//  SearchViewController.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 20/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import CoreLocation
import UIKit

class SearchViewController: UIViewController {
    var client = GTWeatherClient()
    var dataTask: URLSessionDataTask?
    
    var locationService = LocationService()
    var store = Store()
    
    var weather: Weather?
    
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var weatherButton: UIButton!
    
    var fetchWeatherHandler: WeatherResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFetchWeatherHandler()
        getWeatherForLastSearch()
        
        cityField.addTarget(self, action: #selector(didChangeText(sender:)), for: .editingChanged)
    }
    
    @IBAction func didTapGetWeather(_ sender: Any) {
        guard let city = cityField.text,
            !city.isEmpty,
            dataTask == nil
        else { return }

        dataTask = client.weatherForCity(city, completion: fetchWeatherHandler)
    }
    
    @IBAction func didTapForCurrentLocationGetWeahter(_ sender: Any) {
        locationService.start()
    }
    
    @objc func didChangeText(sender: UITextField) {
        weatherButton.isEnabled = (cityField.text != nil) && !(cityField.text?.isEmpty ?? true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "PresentWeather",
            let navDest = segue.destination as? UINavigationController,
            let dest = navDest.viewControllers.first as? WeatherViewController,
            let weather = weather
        else { return }
        
        dest.weather = weather
    }
}

extension SearchViewController: LocationServiceDelegate {
    func didGetCurrentLocation(_ location: CLLocation) {
        guard dataTask == nil else { return }
        
        dataTask = client.weatherForCoordinates(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            completion: fetchWeatherHandler
        )
    }
}

extension SearchViewController {
    func setupFetchWeatherHandler() {
        fetchWeatherHandler = { [weak self] (weatherResp, error) in
            guard let strongSelf = self,
                weatherResp != nil,
                error == nil
            else {
                self?.weather = nil
                self?.dataTask = nil
                return
            }
            
            strongSelf.weather = weatherResp
            strongSelf.dataTask = nil
            
            if let weather = weatherResp {
                strongSelf.store.save(weather: weather)
            }
            
            DispatchQueue.main.async {
                strongSelf.performSegue(withIdentifier: "PresentWeather", sender: strongSelf)
            }
        }
    }
}

extension SearchViewController {
    func getWeatherForLastSearch() {
        guard let lastCoordinate = store.storedWeather() else { return }
        
        dataTask = client.weatherForCoordinates(
            latitude: lastCoordinate.location.lat,
            longitude: lastCoordinate.location.lon,
            completion: fetchWeatherHandler
        )
    }
}
