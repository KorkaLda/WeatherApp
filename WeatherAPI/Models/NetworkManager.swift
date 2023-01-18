//
//  NetworkManager.swift
//  WeatherAPI
//
//  Created by Vladimir on 18.01.2023.
//

import Foundation
import CoreLocation


class NetworkManager{
    
    enum RequestType{
        case cityName(city:String)
        case coordinate(latitude:CLLocationDegrees,longitude:CLLocationDegrees)
    }
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    
    func fetchCurrentWeather(forRequestType requestType:RequestType){
        var urlString = ""
        switch requestType{
        case .cityName(let city): urlString = "https://api.openweathermap.org/data/2.5/weather?appid=234f70f31c9f8fd87414c71893474c7e&q=\(city)&units=metric"
        case .coordinate(let latitude, let longitude): urlString = "https://api.openweathermap.org/data/2.5/weather?appid=234f70f31c9f8fd87414c71893474c7e&lat=\(latitude)&lon=\(longitude)&units=metric"
        }
        performRequest(withUrlString: urlString)
    }
    
    fileprivate func performRequest(withUrlString urlString:String){
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, responce, error in
            if let data = data{
                if let currentWeather = self.parceJSON(withData: data){
                    self.onCompletion?(currentWeather)
                }
            }
        }
        task.resume()
    }
    
    
    
    fileprivate func parceJSON(withData data:Data) -> CurrentWeather?{
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(WeatherData.self, from: data)
            
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else {return nil}
            return currentWeather
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        return nil
    }
}
