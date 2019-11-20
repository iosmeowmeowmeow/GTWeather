//
//  SearchViewController.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 20/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var client = GTWeatherClient()
    
    @IBAction func didTapGetWeather(_ sender: Any) {
        client.weatherForCity("sydney") { (weather, error) in
        }
    }
    
}
