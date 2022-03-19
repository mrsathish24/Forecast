//
//  Constants.swift
//  ForecastTask
//
//  Created by Rifluxyss on 19/03/22.
//

import Foundation
import UIKit

var kForecastDetails = "forecastDetails"
var kForecastsData: Forecasts? {
    get {
        guard let data = UserDefaults.standard.data(forKey: kForecastDetails) else { return nil }
        return try? JSONDecoder().decode(Forecasts.self, from: data)
    }
    set {
        guard let newValue = newValue, let encodedData = try? JSONEncoder().encode(newValue) else { return }
        UserDefaults.standard.set(encodedData, forKey: kForecastDetails)
    }
}


