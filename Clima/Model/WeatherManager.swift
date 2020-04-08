//
//  WeatherManager.swift
//  Clima
//
//  Created by Hoang on 07/04/2020.
//  Copyright © 2020 Hoang. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURLBase = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "7e9009da668c5953afd918212bdc107e"
    var apiPara: String {
        return "&appid=" + apiKey
    }
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = weatherURLBase + "?q=\(cityName)" + "&units=metric" + apiPara
        performRequest(urlString: urlString)
    }
    
    func fetchWeatherWithGPS(latitude: Double, longtitude: Double) {
        let urlString = weatherURLBase + "?lat=\(latitude)&lon=\(longtitude)" + "&units=metric" + apiPara
        performRequest(urlString: urlString)

    }
    
    func performRequest(urlString: String) {
        
        //1. Create an URL
        
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            //3. Give session a task
            
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            //4. Start the task
            task.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            delegate?.didFailWithError(error: error!)
            return
        }
        if let safeData = data {
            if let weather = parseJSON(weatherData: safeData) {
                DispatchQueue.main.async {
                    self.delegate?.didUpdateWeather(weather: weather)
                }
                
            }
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(WeatherData.self, from: weatherData)
            let id = data.weather[0].id
            let temp = data.main.temp
            let name = data.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
