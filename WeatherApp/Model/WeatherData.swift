//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Кирилл on 01.07.2022.
//  Copyright © 2022 Kirill. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
}
