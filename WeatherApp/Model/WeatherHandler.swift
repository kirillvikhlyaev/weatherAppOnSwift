//
//  WeatherHandler.swift
//  WeatherApp
//
//  Created by Кирилл on 01.07.2022.
//  Copyright © 2022 Kirill. All rights reserved.
//

import Foundation

protocol WeatherHandlerDelegate {
    func didUpdateWeather(_ weatherHandler: WeatherHander, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherHander {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=36f5ada500adc5c1a268e92c947c3f34"
    
    var delegate: WeatherHandlerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        perfotmRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        perfotmRequest(with: urlString)
    }
    
    func perfotmRequest(with urlString: String) {
        // 1. Create a URL
        
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            
            let task =  session.dataTask(with: url, completionHandler: {(data, responce, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                } 
            })
            
            // 4. Start the task
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temp: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

