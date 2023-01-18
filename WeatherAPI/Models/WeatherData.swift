//
//  WeatherData.swift
//  WeatherAPI
//
//  Created by Vladimir on 18.01.2023.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        //case feels_like
        case feelsLike = "feels_like"
    }
}

struct Weather: Codable {
    let id:Int
    let description:String
}
