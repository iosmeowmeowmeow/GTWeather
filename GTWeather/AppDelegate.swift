//
//  AppDelegate.swift
//  GTWeather
//
//  Created by Emmanuel Tugado on 19/11/19.
//  Copyright © 2019 Emmanuel Tugado. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let countryRaw = Bundle.main.object(forInfoDictionaryKey: "Country") as? String,
           let country = BaseCountry(rawValue: countryRaw) {
            UINavigationBar.appearance().backgroundColor = country.backgroundColor
            UINavigationBar.appearance().tintColor = country.tintColor
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

enum BaseCountry: String, ColorConfigurator {
    case australia = "au"
    case canada = "ca"

    var backgroundColor: UIColor {
        switch self {
        case .australia: return .blue
        case .canada: return .red
        }
    }

    var tintColor: UIColor {
        switch self {
        case .australia: return .white
        case .canada: return .red
        }
    }
}

protocol ColorConfigurator {
    var backgroundColor: UIColor { get }
    var tintColor: UIColor { get }
}
