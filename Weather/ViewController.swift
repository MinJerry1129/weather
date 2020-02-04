//
//  ViewController.swift
//  Weather
//
//  Created by Admin on 27/11/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import CoreLocation
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var WeatherTB: UITableView!
    var today : Double!
    var city : String!
    var latitude : String!
    var longtitude : String!
    var country : String!
    var AllWeather = [Weather]()
    var detailVC : DetailVC!
    let locationManager = CLLocationManager()
    @IBOutlet weak var lbcity: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherTB.delegate = self
        WeatherTB.dataSource = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = "\(locValue.latitude)"
        longtitude = "\(locValue.longitude)"
        print("locations = " + latitude + ":" + longtitude)
        print("https://api.openweathermap.org/data/2.5/forecast?appid=08389b845ce6720d39c29f748834b001&lat=" + latitude + "&lon" + longtitude)
        setready()
    }
    
    //Request Weather forecast code
    func setready(){
        Alamofire.request("https://api.openweathermap.org/data/2.5/forecast?appid=08389b845ce6720d39c29f748834b001&lat=" + latitude + "&lon=" + longtitude, method: .get).responseJSON{ response in
        print(response)
        
            if let value = response.value as? [String: AnyObject] {
                let city = value["city"] as? [String: Any]
                let cityname = city!["name"] as! String
                let country = city!["country"] as! String
                self.lbcity.text = cityname + ", " + country
                let list = value["list"] as? [[String: Any]]
                for i in 0 ... (list?.count)!-1 {
                    let datetime = list?[i]["dt_txt"] as! String
                    let weatherdes = list?[i]["weather"] as? [[String: Any]]
                    let main_des = weatherdes?[0]["main"] as! String
                    let description = weatherdes?[0]["description"] as! String
                    let main = list?[i]["main"] as? [String: Any]

                    let temp :Double = main?["temp"] as! Double
                    let tempmax : Double = main?["temp_max"] as! Double
                    let tempmin : Double = main?["temp_min"] as! Double

                    let oneCell = Weather(datetime: datetime, temp: "\(round(100*(temp - 273.15))/100)", tempMax: "\(round(100*(tempmax - 273.15))/100)" , tempMin: "\(round(100*(tempmin - 273.15))/100)", maindes: main_des, description: description)

                    self.AllWeather.append(oneCell)
                }
                self.WeatherTB.reloadData()
            }
        
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.WeatherTB.dequeueReusableCell(withIdentifier: "cell") as! WeatherCell
//        var dateFormater : DateFormatter = DateFormatter()
//        dateFormater.dateFormat = "yyyy-MM-dd"
        
        cell.txtDate.text = AllWeather[indexPath.row].datetime
        cell.txtDegree.text = AllWeather[indexPath.row].temp + " °C"
        if AllWeather[indexPath.row].maindes == "Rain"{
            cell.WeatherImg.image = UIImage.init(named: "rain")
        }else if AllWeather[indexPath.row].maindes == "Clouds"{
            cell.WeatherImg.image = UIImage.init(named: "cloudy")
        }else if AllWeather[indexPath.row].maindes == "Snow"{
            cell.WeatherImg.image = UIImage.init(named: "snow")
        }else if AllWeather[indexPath.row].maindes == "Clear"{
            cell.WeatherImg.image = UIImage.init(named: "sunny")
        }
        
        
//            dateFormater.string(from: Date(timeIntervalSince1970: (today + Double(indexPath.row  * 60 * 60 * 24)) as! TimeInterval))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Defaults.save(AllWeather[indexPath.row].maindes, with: Defaults.MAINDES_KEY)
        Defaults.save(AllWeather[indexPath.row].temp, with: Defaults.TEMP_KEY)
        Defaults.save(AllWeather[indexPath.row].tempMax, with: Defaults.TEMPMAX_KEY)
        Defaults.save(AllWeather[indexPath.row].tempMin, with: Defaults.TEMPMIN_KEY)
        Defaults.save(AllWeather[indexPath.row].datetime, with: Defaults.DATE_KEY)
        Defaults.save(AllWeather[indexPath.row].description, with: Defaults.DES_KEY)
        self.detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as? DetailVC
        self.detailVC.modalPresentationStyle = .fullScreen
        self.present(self.detailVC, animated: true, completion: nil)        
    }

}

