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
        bindSignals()
    }
    
    func bindSignals() {
        
        DynamicProperty(object: currentLocationButton, keyPath: "selected")
            .producer
            .observeOn(UIScheduler())
            .on(next: {
                self.mapView.showsUserLocation = ($0 as! NSNumber) == true ? true : false
            })
            .start()
        
        
    }
}


extension CBCrumbsMapViewController : CLLocationManagerDelegate {
    
}
