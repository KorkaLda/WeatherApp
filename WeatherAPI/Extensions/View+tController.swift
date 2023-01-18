//
//  View+tController.swift
//  WeatherAPI
//
//  Created by Vladimir on 18.01.2023.
//

import UIKit

extension ViewController{
    func presentSearchAlertController(withTutle title:String?, message:String, style: UIAlertController.Style, completionHandler: @escaping (String)->Void){
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField{ tf in
            let cities = ["Moscow","London","Stambul","New York"]
            tf.placeholder = cities.randomElement()
        }
        
        let search = UIAlertAction(title: "Search", style: .default){ action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else {return}
            if cityName != ""{
                
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
                
//                self.networkManager.fetchCurrentWeather(forCity: cityName)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
}
