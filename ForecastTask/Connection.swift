//
//  Connection.swift
//  ForecastTask
//
//  Created by Rifluxyss on 19/03/22.
//

import Foundation
import UIKit

class Connection {
    static let shared = Connection()
    
    static let APIKey = "" //522db6a157a748e2996212343221502 Added static key
    static let BaseURL = URL(string: "https://api.weatherapi.com/v1/forecast.json")
    
    func getForecastJson(completion: @escaping (Forecasts)-> ()) {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(Connection.APIKey)&q=Guindy&days=7&aqi=no&alerts=no"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {data, res, err in
                if let data = data {
                    let decoder = JSONDecoder()
                    if let json = try? decoder.decode(Forecasts.self, from: data) {
                        completion(json)
                    }
                }
            }.resume()
        }
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    func getFormattedDate(date: Date, format: String) -> String {
            let dateformat = DateFormatter()
            dateformat.dateFormat = format
            return dateformat.string(from: date)
    }
}

extension Double {

   var toString: String {
      return NSNumber(value: self).stringValue
   }

}
