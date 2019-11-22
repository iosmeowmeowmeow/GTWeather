//
//  RecentSearchTableViewCell.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 22/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import UIKit

class RecentSearchTableViewCell: UITableViewCell, DataPresenter {
    func present(data: String) {
        textLabel?.text = nil
        textLabel?.text = data
    }
}
