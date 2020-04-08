//
//  WeatherData.swift
//  Clima
//
//  Created by Hoang on 07/04/2020.
//  Copyright © 2020 Hoang. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
    let icon: String
}
