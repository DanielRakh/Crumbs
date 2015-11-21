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

    
    let kDistanceMeters:CLLocationDistance = 500
    var shouldInitiallyZoom = true
    
    let realm = try! Realm()
    var crumbs = try! Realm().objects(CBCrumbResponseEntity)
    
    var isMonitoring = false
    var crumbAnnotations = [CBCrumbAnnotation]()
    
    
    @IBOutlet weak var monitoringButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    
    private let locationManager = CLLocationManager()
    
    
    @IBAction func locationBarButtonItemDidTap(sender: AnyObject) {
        zoomIntoCurrentLocation()
    }
    
    @IBAction func monitoringButtonDidTap(sender: AnyObject) {
        
        print("PRESS")
        
        if isMonitoring == false {
            
            self.monitoringButton.setTitle("Stop Monitoring", forState: .Normal)
            for annotation in crumbAnnotations {
                startMonitoringAnnotation(annotation)
            }
        
            showSimpleAlertWithTitle("Monitoring started bruh!", message: "Fingers crossed.", viewController: self)
    
            isMonitoring = true
            
            print(self.mapView.annotations)
            
        } else {
            
            showSimpleAlertWithTitle("Monitoring stopped bruh!", message: "Fuck off!", viewController: self)
            
            self.monitoringButton.setTitle("Start Monitoring", forState: .Normal)
            for annotation in crumbAnnotations {
                stopMonitoringAnnotation(annotation)
            }
            isMonitoring = false
            
            print(self.mapView.annotations)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitoringButton.layer.cornerRadius = 19.0
        
        // Delegate Setup
        mapView.delegate = self
        locationManager.delegate = self
        
        setupLocationManager()
        addAnnotations(crumbs)
        
        
    }

    
    func addAnnotations(crumbs:Results<CBCrumbResponseEntity>) {
        for crumb in crumbs {
            
            let radius = 15.0
        
            let annotation = CBCrumbAnnotation(coordinate: CLLocationCoordinate2DMake(crumb.latitude, crumb.longitude), radius:radius , image:nil, identifier:"\(crumb.id)", title: crumb.title!, subtitle: "Radius: \(radius)m - On Entry")
            
            mapView?.addOverlay(MKCircle(centerCoordinate: annotation.coordinate, radius: annotation.radius))
           
//            networkService.producerToRequestImage(crumb.imageURL!).startOn(QueueScheduler.mainQueueScheduler)
//                .takeUntil(self.racutil_willDeallocProducer)
//                .on(next: {
//                    annotation.image = $0
//                }).observeOn(UIScheduler())
//                .start()
            
            
            self.mapView.addAnnotation(annotation)
            self.crumbAnnotations.append(annotation)
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
    
    
    func regionWithAnnotation(annotation: CBCrumbAnnotation) -> CLCircularRegion {
        
        let region = CLCircularRegion(center: annotation.coordinate, radius: annotation.radius, identifier: annotation.identifier!)
        region.notifyOnEntry = true
        return region
    }
    
    
    func startMonitoringAnnotation(annotation: CBCrumbAnnotation) {
        
        
        guard CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) else {
            showSimpleAlertWithTitle("Error", message: "Geofencing is not supported on this device!", viewController: self)
            return
        }
        
        guard CLLocationManager.authorizationStatus() == .AuthorizedAlways else {
            showSimpleAlertWithTitle("Warning", message: "Your crumb is saved but will only be activated once you grant the app permission to access the device location.", viewController: self)
            return
        }
        
        let region = regionWithAnnotation(annotation)
        locationManager.startMonitoringForRegion(region)
        
    }
    
    
    func stopMonitoringAnnotation(annotation:CBCrumbAnnotation) {
        
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion else {
                return
            }
        
            guard circularRegion.identifier == annotation.identifier else {
                return
            }
            
            locationManager.stopMonitoringForRegion(circularRegion)
        }
    }
    
    

    
    
    // Helpers
    
    func zoomIntoCurrentLocation() {
        if self.mapView.userLocation.location != nil {
            zoomToCurrentLocationOnMap(self.mapView, locationCoordinate: self.mapView.userLocation.coordinate, regionDistance: (kDistanceMeters, kDistanceMeters))
        }
    }
    
    func zoomToCurrentLocationOnMap(mapView:MKMapView, locationCoordinate:CLLocationCoordinate2D, regionDistance: (lat:CLLocationDistance, long:CLLocationDistance)) {
        
        mapView.centerCoordinate = locationCoordinate
        let region = MKCoordinateRegionMakeWithDistance(locationCoordinate, regionDistance.lat, regionDistance.long)
        mapView.setRegion(region, animated: true)
        
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
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.animatesDrop = true
        }
        else {
            annotationView?.annotation = annotation
        }
        

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
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        showSimpleAlertWithTitle("Error! Monitoring failed for region: \(region?.identifier)", message: "\(error.localizedDescription)", viewController: self)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        showSimpleAlertWithTitle("Error! Location Manager faild with the following error:", message: "\(error.localizedDescription)", viewController: self)
    }
    
}
