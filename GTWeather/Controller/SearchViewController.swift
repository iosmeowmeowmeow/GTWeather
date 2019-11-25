//
//  SearchViewController.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 20/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import CoreLocation
import UIKit

enum SearchMethod: Int {
    case name, zipCode
}

class SearchViewController: UIViewController {
    var client = GTWeatherClient()

    var dataTask: URLSessionDataTask? {
        willSet {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }

                if newValue == nil {
                    strongSelf.activityIndicator.stopAnimating()
                    strongSelf.activityIndicator.isHidden = true

                    strongSelf.weatherButton.isEnabled = true
                    strongSelf.currentWeatherButton.isEnabled = true
                    strongSelf.recentBarButton.isEnabled = true
                } else {
                    strongSelf.activityIndicator.startAnimating()
                    strongSelf.activityIndicator.isHidden = false

                    strongSelf.weatherButton.isEnabled = false
                    strongSelf.currentWeatherButton.isEnabled = false
                    strongSelf.recentBarButton.isEnabled = false
                }
            }
        }
    }

    var locationService = LocationService()
    var store = Store()
    
    var weather: Weather?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var currentWeatherButton: UIButton!
    @IBOutlet weak var recentBarButton: UIBarButtonItem!
    @IBOutlet weak var methodSegControl: UISegmentedControl!

    var fetchWeatherHandler: WeatherResponse!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        locationService.delegate = self
        
        getWeatherForLastSearch()

        cityField.attributedPlaceholder = NSAttributedString(
            string: "Search Here",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        cityField.addTarget(self, action: #selector(didChangeText(sender:)), for: .editingChanged)
    }
    
    @IBAction func didTapGetWeather(_ sender: Any) {
        guard let searchText = cityField.text,
            !searchText.isEmpty,
            dataTask == nil,
            let searchMethod = SearchMethod(rawValue: methodSegControl.selectedSegmentIndex)
        else { return }

        setupFetchWeatherHandler(shouldSaveLocation: true)

        switch searchMethod {
        case .name:
            dataTask = client.weatherForCity(searchText, completion: fetchWeatherHandler)
        case .zipCode:
            dataTask = client.weatherForZIPCode(searchText, completion: fetchWeatherHandler)
        }
    }
    
    @IBAction func didTapForCurrentLocationGetWeahter(_ sender: Any) {
        locationService.start()
    }
    
    @objc func didChangeText(sender: UITextField) {
        weatherButton.isEnabled = (cityField.text != nil) && !(cityField.text?.isEmpty ?? true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentWeather",
            let navDest = segue.destination as? UINavigationController,
            let dest = navDest.viewControllers.first as? WeatherViewController,
            let weather = weather {
            dest.weather = weather
        } else if segue.identifier == "RecentSearches",
            let dest = segue.destination as? RecentSearchViewController {
            dest.store = store
        }
    }
}

extension SearchViewController: LocationServiceDelegate {
    func didGetCurrentLocation(_ location: CLLocation) {
        getWeatherForCoordinates(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
}

extension SearchViewController {
    func setupFetchWeatherHandler(shouldSaveLocation: Bool) {
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
                
                if shouldSaveLocation {
                    strongSelf.store.save(location: weather.locationName)
                }
            }
            
            DispatchQueue.main.async {
                strongSelf.performSegue(withIdentifier: "PresentWeather", sender: strongSelf)
            }
        }
    }
}

extension SearchViewController {
    fileprivate func getWeatherForCoordinates(lat: Double, lon: Double) {
        guard dataTask == nil else { return }
        
        setupFetchWeatherHandler(shouldSaveLocation: false)
        
        dataTask = client.weatherForCoordinates(
            latitude: lat,
            longitude: lon,
            completion: fetchWeatherHandler
        )
    }
    
    func getWeatherForLastSearch() {
        guard let lastCoordinate = store.storedWeather() else { return }
        
        getWeatherForCoordinates(lat: lastCoordinate.location.lat, lon: lastCoordinate.location.lon)
    }
}
