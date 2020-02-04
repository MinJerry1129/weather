//
//  ViewController.swift
//  Maps Demo
//
//  Created by Alex Tarragó on 12/11/2019.
//  Copyright © 2019 Dribba GmbH. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class MapviewController: UIViewController {
    private let locationManager = CLLocationManager()
    @IBOutlet weak var MapviewUV: GMSMapView!
    @IBOutlet weak var Addresstxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        MapviewUV.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

       
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        let address = Addresstxt.text!
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                return
            }
            print(placemarks.first?.country!)
            print(placemarks.first?.locality!)
        }
    }
    @IBAction func CurrentSelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MapviewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        MapviewUV.isMyLocationEnabled = true
        MapviewUV.settings.myLocationButton = true
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        MapviewUV.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
    }
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
    }
    
}
extension MapviewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
//        let lat = mapView.camera.target.latitude
//        print(lat)
//
//        let lon = mapView.camera.target.longitude
//        print(lon)
//        locatonLbl.text = "Latitude: "+"\(lat)" + "\n" + "Longitude: " + "\(lon)"
//        locationStr = "\(lat)" + "," + "\(lon)"
    }
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        print("adfadf")
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        let marker = GMSMarker(position: coordinate)
        marker.title = "Current Position"
        marker.map = mapView
        
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                
                return
            }
           
            
            print(address)
            print(address.country!)
            Defaults.save(address.locality!, with: Defaults.CITY_KEY)
            Defaults.save(address.country!, with: Defaults.COUNTRY_KEY)
//            self.addressLbl.text = lines.joined(separator: "\n")
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
        
        
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        
//        locatonLbl.text = "Latitude: "+"\(lat)" + "\n" + "Longitude: " + "\(lon)"
//        locationStr = "\(lat)" + "," + "\(lon)"
    }
    
}


