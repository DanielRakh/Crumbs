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
import RealmSwift

class CBCrumbsMapViewController: UIViewController {
    
    let networkService = CBNetworkingService()
    
    
    let kDistanceMeters:CLLocationDistance = 500
    var shouldInitiallyZoom = true
    
    let realm = try! Realm()
    var crumbs = try! Realm().objects(CBCrumbResponseEntity)
//    var crumbsAnnotations = [CBCrumbAnnotation]()
    
    
    
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
        
        setupLocationManager()
        addAnnotations(crumbs)
        
        
    }

    
    func addAnnotations(crumbs:Results<CBCrumbResponseEntity>) {
        for crumb in crumbs {
        
            let annotation = CBCrumbAnnotation(coordinate: CLLocationCoordinate2DMake(crumb.latitude, crumb.longitude), radius:50.0 , image:nil , title: crumb.title!, subtitle: nil)
            
            mapView?.addOverlay(MKCircle(centerCoordinate: annotation.coordinate, radius: annotation.radius))
           
//            networkService.producerToRequestImage(crumb.imageURL!).startOn(QueueScheduler.mainQueueScheduler)
//                .takeUntil(self.racutil_willDeallocProducer)
//                .on(next: {
//                    annotation.image = $0
//                }).observeOn(UIScheduler())
//                .start()
            
            
            self.mapView.addAnnotation(annotation)
        }
        
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
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "myCrumb"
        
        guard annotation is CBCrumbAnnotation else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        
        guard annotationView == nil else {
            print("GUARD")
            annotationView?.annotation = annotation
//            annotationView?.image = (annotation as! CBCrumbAnnotation).image
//            print(annotationView?.image)

            return annotationView
        }
        
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//        annotationView?.image = (annotation as! CBCrumbAnnotation).image
        annotationView?.canShowCallout = true
        annotationView?.animatesDrop = true
        
//        print(annotationView?.image)
        
        return annotationView
    }
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {

        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.lineWidth = 1.0
        circleRenderer.strokeColor = UIColor.purpleColor()
        circleRenderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
        return circleRenderer
 
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
