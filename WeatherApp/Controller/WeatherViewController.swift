//
//  ViewController.swift
//  WeatherApp
//
//  Created by Кирилл on 01.07.2022.
//  Copyright © 2022 Kirill. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherHandler = WeatherHander()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherHandler.delegate = self
        searchTextField.delegate = self // Установка делегата на филд
    }
}

// MARK: - UITextFieldDelegateSection

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // Нажатие на клавишу на клавиатуре
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { // Валидация
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter the city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) { // Действие в конце работы с филдом
        
        // Используем информацию с филда
        if let cityName = searchTextField.text {
            weatherHandler.fetchWeather(cityName: cityName)
        }
        
        searchTextField.text = ""
    }
    @IBAction func onSearchTap(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
}

// MARK: - WeatherHandlerDelegateSection

extension WeatherViewController: WeatherHandlerDelegate {
    
    func didUpdateWeather(_ weatherHandler: WeatherHander, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = weather.tempString + "℃"
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print("Возникла ошибка: \(error)")
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            weatherHandler.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Возникла ошибка: \(error)")
    }
    
    
    @IBAction func onLocationTap(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}
