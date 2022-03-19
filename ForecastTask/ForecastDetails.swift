//
//  ForecastDetails.swift
//  ForecastTask
//
//  Created by Rifluxyss on 19/03/22.
//

import Foundation

struct Forecasts: Codable {
    var location: CityInfo
    var forecast: Forecast
}

struct CityInfo: Codable {
    var country: String
    var name: String
    var localtime: String
}

struct Forecast: Codable {
    var forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    var date: String
    var day: Day
}

struct Day: Codable {
    var maxtemp_c: Double
    var mintemp_c: Double
    var condition: Condition
    
}

struct Condition: Codable {
    var icon: String
}
