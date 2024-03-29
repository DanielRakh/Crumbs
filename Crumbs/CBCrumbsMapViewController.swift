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
    
    
    private let kDistanceMeters:CLLocationDistance = 500
    private var shouldInitiallyZoom = true
    private var isMonitoring = false
    
    private var crumbAnnotations = [CBCrumbAnnotation]()
    private let locationManager = CLLocationManager()

    var viewModel:CBCrumbsMapViewModeling? {
        
        didSet {
            
            if let viewModel = viewModel {
                
                viewModel.crumbAnnotations.producer.observeOn(UIScheduler())
                    .on(next: { annotations in
                        self.crumbAnnotations = annotations
                        self.mapView?.addAnnotations(annotations)
                    }).start()
                
                viewModel.crumbOverlays.producer.observeOn(UIScheduler())
                    .on(next: { overlays in
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.mapView?.addOverlays(overlays)
                        })
                    }).start()

            }
        }
    }
    
    @IBOutlet weak var monitoringButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    
    @IBAction func locationBarButtonItemDidTap(sender: AnyObject) {
        zoomIntoCurrentLocation()
    }
    
    @IBAction func monitoringButtonDidTap(sender: AnyObject) {
        
        if isMonitoring == false {
            
            self.monitoringButton.setTitle("Stop Monitoring", forState: .Normal)
            for annotation in crumbAnnotations {
                startMonitoringAnnotation(annotation)
            }
            
            showSimpleAlertWithTitle("Monitoring started bruh!", message: "Fingers crossed.", viewController: self)
            
            isMonitoring = true
            
        } else {
            
            showSimpleAlertWithTitle("Monitoring stopped bruh!", message: "Fuck off!", viewController: self)
            
            self.monitoringButton.setTitle("Start Monitoring", forState: .Normal)
            for annotation in crumbAnnotations {
                stopMonitoringAnnotation(annotation)
            }
            isMonitoring = false
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monitoringButton.layer.cornerRadius = 19.0
        
        // Delegate Setup
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        
        if locationManager.monitoredRegions.count == 0 {
            isMonitoring = false
            self.monitoringButton.setTitle("Start Monitoring", forState: .Normal)
        } else {
            isMonitoring = true
            self.monitoringButton.setTitle("Stop Monitoring", forState: .Normal)
        }
        
        
        
        viewModel?.fetchAnnotations()
        

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
    
    
    func regionWithAnnotation(annotation: CBCrumbAnnotation) -> CLCircularRegion {
        
        let region = CLCircularRegion(center: annotation.coordinate, radius: annotation.radius, identifier: "\(annotation.id)")
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
            
            guard circularRegion.identifier == "\(annotation.id)" else {
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
        
        configureDetailView(annotationView!)
        
        return annotationView
    }
    
    
    func configureDetailView(annotationView: MKAnnotationView) {
        let width = 300
        let height = 200
        
        let snapshotView = UIView()
        let views = ["snapshotView": snapshotView]
        snapshotView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[snapshotView(300)]", options: [], metrics: nil, views: views))
        snapshotView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[snapshotView(200)]", options: [], metrics: nil, views: views))
 
        
        annotationView.detailCalloutAccessoryView = snapshotView

        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        spinner.center = CGPoint(x: (annotationView.detailCalloutAccessoryView?.bounds.size.width)!/2, y: (annotationView.detailCalloutAccessoryView?.bounds.size.height)!/2)
        annotationView.detailCalloutAccessoryView?.addSubview(spinner)
        annotationView.detailCalloutAccessoryView?.bringSubviewToFront(spinner)


        spinner.startAnimating()
        
        
        self.viewModel?.getCrumbImage(((annotationView.annotation as? CBCrumbAnnotation)?.imageURL!)!).on(next: {
            spinner.stopAnimating()
              imageView.image = $0
        }).start()
        
        
        
        snapshotView.addSubview(imageView)
        

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
