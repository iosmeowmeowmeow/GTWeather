//
//  WeatherViewController.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 19/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBAction func didTapCloseButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
