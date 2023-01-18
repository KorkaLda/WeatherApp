//
//  ViewController.swift
//  WeatherAPI
//
//  Created by Vladimir on 18.01.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    var networkManager = NetworkManager()
    lazy var locationManager:CLLocationManager = {
       let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else {return}
            self.updateInterfaceWith(weather: currentWeather)
        }
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestLocation()
        }
    }

    @IBAction func locationButton(_ sender: UIButton) {
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestLocation()
        }
        
    }
    
    
    
    
    @IBAction func searchButton(_ sender: UIButton) {
        self.presentSearchAlertController(withTutle: "enter city name", message: "", style: .alert) {[unowned self] cityName in
            self.networkManager.fetchCurrentWeather(forRequestType: .cityName(city: cityName))
        }
    }
    
    func updateInterfaceWith(weather: CurrentWeather){
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.tempString + " ºC"
            self.weatherImageView.image = UIImage(systemName: weather.systemIconNameString)
            self.weatherDescriptionLabel.text = weather.description
            self.feelsLikeLabel.text = "Feels like \(weather.feelsLikeTempString) ºC"
        }
        
    }
    
}

//MARK: -  CLLocationManager Delegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let lalitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        networkManager.fetchCurrentWeather(forRequestType: .coordinate(latitude: lalitude, longitude: longitude))
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
