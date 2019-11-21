//
//  DetailTableViewCell.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 21/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import UIKit

protocol DataPresenter {
    associatedtype T
    func present(data: T)
}

class DetailTableViewCell: UITableViewCell, DataPresenter {
    func present(data: (String, String)) {
        textLabel?.text = nil
        detailTextLabel?.text = nil
        
        textLabel?.text = data.0
        detailTextLabel?.text = data.1
    }
}
