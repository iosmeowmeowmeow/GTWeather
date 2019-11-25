//
//  RecentSearchViewController.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 22/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import UIKit

class RecentSearchViewController: UIViewController {
    var store: Store!
    var viewModels: [RecentSearchViewModel] = [] {
        didSet { DispatchQueue.main.async { self.tableView.reloadData() } }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        viewModels = store.storedLocations().reversed().compactMap { RecentSearchViewModel(locationName: $0) }
    }

    @IBAction func didTapClearButton(_ sender: Any) {
        store.clearStoredLocations()
        viewModels = []
    }
}

extension RecentSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath) as? RecentSearchTableViewCell,
            indexPath.row < viewModels.count
        else { return UITableViewCell() }
        
        cell.present(data: viewModels[indexPath.row].locationName)
        
        return cell
    }
}
