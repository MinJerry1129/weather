//
//  DetailVC.swift
//  Weather
//
//  Created by Admin on 29/11/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var WImage: UIImageView!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var Temp: UILabel!
    @IBOutlet weak var TempMin: UILabel!
    @IBOutlet weak var Description: UILabel!
    
    @IBOutlet weak var TempMax: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if Defaults.getNameAndValue(Defaults.MAINDES_KEY) == "Rain"{
            WImage.image = UIImage.init(named: "rain")
        }else if  Defaults.getNameAndValue(Defaults.MAINDES_KEY)  == "Clouds"{
            WImage.image = UIImage.init(named: "cloudy")
        }else if  Defaults.getNameAndValue(Defaults.MAINDES_KEY)  == "Snow"{
            WImage.image = UIImage.init(named: "snow")
        }else if  Defaults.getNameAndValue(Defaults.MAINDES_KEY)  == "Clear"{
            WImage.image = UIImage.init(named: "sunny")
        }
        dateTime.text = "Date:  " + Defaults.getNameAndValue(Defaults.DATE_KEY)
        Temp.text = "Temperature: " + Defaults.getNameAndValue(Defaults.TEMP_KEY) + " °C"
        TempMin.text = "Max Temperature: " + Defaults.getNameAndValue(Defaults.TEMPMIN_KEY) + " °C"
        TempMax.text = "Min Temperature: " + Defaults.getNameAndValue(Defaults.TEMPMAX_KEY) + " °C"
        Description.text = "Description: " + Defaults.getNameAndValue(Defaults.DES_KEY)
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
