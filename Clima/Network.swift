//
//  Network.swift
//  Clima
//
//  Created by Alexandre Scheer Bing on 22/04/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class Network{
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
//    let APP_ID = "acb1a5fb5d2a5e94d9e2c9cb892ae477"
    
    var weatherData = WeatherDataModel()
    var success : Bool = false
    var pending: Bool = true

    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(parameters: [String : String]){
        pending = true
        Alamofire.request(self.WEATHER_URL, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let weatherJSON : JSON =  JSON(response.result.value)
                self.success = true
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(response.result.error)")
            }
            self.pending = false
        }
    }
    
    func updateWeatherData(json: JSON) {
        if let tempResult = json["main"]["temp"].double{
            
            weatherData.temperature = Int(tempResult - 273.15)
            
            weatherData.city = json["name"].stringValue
            
            weatherData.condition = json["weather"][0]["id"].intValue
            
            weatherData.weatherIconName = weatherData.updateWeatherIcon(condition: weatherData.condition)
            
        } else {
            weatherData.city = "Previsão indisponível"
        }
    }
}
