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
    
    var weather: Weather?
    
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var weatherButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityField.addTarget(self, action: #selector(didChangeText(sender:)), for: .editingChanged)
        
        locationService.delegate = self
        locationService.start()
    }
    
    @IBAction func didTapGetWeather(_ sender: Any) {
        guard let city = cityField.text,
            !city.isEmpty,
            dataTask == nil
        else { return }

        dataTask = client.weatherForCity(city) { [weak self] (weatherResp, error) in
            guard let strongSelf = self,
                weatherResp != nil,
                error == nil
            else {
                self?.weather = nil
                return
            }
            
            strongSelf.weather = weatherResp
            
            DispatchQueue.main.async {
                strongSelf.performSegue(withIdentifier: "PresentWeather", sender: strongSelf)
            }
        }
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
        
    }
}
