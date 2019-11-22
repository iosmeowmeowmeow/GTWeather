//
//  WeatherViewController.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 19/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    var weather: Weather!
    var viewModels = [DetailViewModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModels = viewModelsForWeather(weather)
        
        title = weather.locationName.capitalized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailTableViewCell,
            indexPath.row < viewModels.count
        else { return UITableViewCell() }
        
        let viewModel = viewModels[indexPath.row]
        cell.present(data: (viewModel.title, viewModel.details))
        
        return cell
    }
}

extension WeatherViewController {
    func viewModelsForWeather(_ weather: Weather) -> [DetailViewModel] {
        return [
            DetailViewModel(title: "Summary", details: weather.description.capitalized),
            DetailViewModel(title: "Pressure", details: "\(weather.mainData.pressure)"),
            DetailViewModel(title: "Humidity", details: "\(weather.mainData.humidity)"),
            DetailViewModel(title: "Average Temperature", details: "\(weather.mainData.temperatureAverage)"),
            DetailViewModel(title: "Lowest Temperature", details: "\(weather.mainData.temperatureMin)"),
            DetailViewModel(title: "Highest Temperature", details: "\(weather.mainData.temperatureMax)"),
            DetailViewModel(title: "Wind Speed", details: "\(weather.wind.windSpeed)"),
            DetailViewModel(title: "Wind Direction", details: "\(weather.wind.windDirection)")
        ]
    }
}
