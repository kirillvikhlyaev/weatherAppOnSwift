//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Кирилл on 01.07.2022.
//  Copyright © 2022 Kirill. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temp: Double
    
    var tempString: String {
        return String(format: "%.1f", temp)
    }
    
    var conditionName: String {
       switch conditionId {
        case 200...232:
            return "cloud.bolt.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 701...781:
            return "cloud.fog.fill"
        case 801...804:
            return "cloud.sun.fill"
        default:
            return "sun.max.fill"
        }
    }
}
