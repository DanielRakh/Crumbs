//
//  CBCrumbsMapViewController.swift
//  Crumbs
//
//  Created by Daniel on 11/18/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import ReactiveCocoa

class CBCrumbsMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    
    private let locationManager = CLLocationManager()
    
    
    @IBAction func locationBarButtonItemDidTap(sender: AnyObject) {
        self.currentLocationButton.selected = !self.currentLocationButton.selected
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        bindSignals()
    }
    
    func bindSignals() {
        
        DynamicProperty(object: currentLocationButton, keyPath: "selected")
            .producer
            .observeOn(UIScheduler())
            .on(next: {
                
                if ($0 as! NSNumber) == true {
                    self.mapView.showsUserLocation = true
                    self.locationManager.startUpdatingLocation()
            
                } else {
                    self.locationManager.stopUpdatingLocation()
                    self.mapView.showsUserLocation = false
                }
            })
            .start()
        
        
    }
}


extension CBCrumbsMapViewController : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first!
        self.mapView.centerCoordinate = location.coordinate
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
        self.mapView.setRegion(region, animated: true)
    }
}
