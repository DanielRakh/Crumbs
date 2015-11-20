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
    
    
    let kDistanceMeters:CLLocationDistance = 500
    var shouldInitiallyZoom = true
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    
    private let locationManager = CLLocationManager()
    
    
    @IBAction func locationBarButtonItemDidTap(sender: AnyObject) {
        zoomIntoCurrentLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate Setup
        mapView.delegate = self
        locationManager.delegate = self

        bindSignals()
        setupLocationManager()
    }
    
    
    func setupLocationManager() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if (CLLocationManager.authorizationStatus() == .NotDetermined) {
            locationManager.requestAlwaysAuthorization()
        } else {
            mapView.showsUserLocation = true
            zoomIntoCurrentLocation()
        }
        
        
    }
    
    
    func bindSignals() {
        
        
//        let btnaction = CocoaAction(self.currentLocationButton
//        
//        
//        DynamicProperty(object: currentLocationButton, keyPath: "selected")
//            .producer
//            .observeOn(UIScheduler())
//            .on(next: {
//                self.shouldZoom = ($0 as! NSNumber) == true ?  true : false
//                self.mapView.showsUserLocation = ($0 as! NSNumber) == true ? true : false
//            })
//            .start()
        
    }
    
    
    // Helpers
    
    func zoomIntoCurrentLocation() {
        if self.mapView.userLocation.location != nil {
            zoomToCurrentLocationOnMap(self.mapView, locationCoordinate: self.mapView.userLocation.coordinate, regionDistance: (kDistanceMeters, kDistanceMeters))
        }
    }
    

}



extension CBCrumbsMapViewController : MKMapViewDelegate {

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        if shouldInitiallyZoom {
            zoomToCurrentLocationOnMap(mapView, locationCoordinate: userLocation.coordinate, regionDistance: (kDistanceMeters, kDistanceMeters))
            shouldInitiallyZoom = !shouldInitiallyZoom
        }
        
    }
    
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        print(error)
    }
}


extension CBCrumbsMapViewController : CLLocationManagerDelegate {
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 
        print("location manager")
        
        let location = locations.first!
        
//        zoomToCurrentLocationOnMap(mapView, locationCoordinate: location.coordinate, regionDistance: (1500,1500))

        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    
    
    // Helpers
    
    func zoomToCurrentLocationOnMap(mapView:MKMapView, locationCoordinate:CLLocationCoordinate2D, regionDistance: (lat:CLLocationDistance, long:CLLocationDistance)) {
        
        mapView.centerCoordinate = locationCoordinate
        let region = MKCoordinateRegionMakeWithDistance(locationCoordinate, regionDistance.lat, regionDistance.long)
        mapView.setRegion(region, animated: true)
        
    }
    
}
