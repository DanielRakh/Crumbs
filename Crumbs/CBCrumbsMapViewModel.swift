//
//  CBCrumbsMapViewModel.swift
//  Crumbs
//
//  Created by Daniel on 11/21/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import Foundation
import ReactiveCocoa
import RealmSwift
import MapKit


class CBCrumbsMapViewModel : CBCrumbsMapViewModeling {
    
    var crumbAnnotations:AnyProperty<[CBCrumbAnnotation]> {
        return AnyProperty(annotations)
    }
    
    var crumbOverlays:AnyProperty<[MKOverlay]> {
        return AnyProperty(overlays)
    }
    
    
    private let annotations = MutableProperty<[CBCrumbAnnotation]>([CBCrumbAnnotation]())
    private let overlays = MutableProperty<[MKOverlay]>([MKOverlay]())
    
    
    private let kRadiusMeters:CLLocationDistance = 15.0
    
    
    func fetchAnnotations() {
        
        do {
            
            let realm = try Realm()
            
            self.annotations.value = realm.objects(CBCrumbResponseEntity).map { crumb in
                return CBCrumbAnnotation(
                    coordinate:
                    CLLocationCoordinate2D(latitude: crumb.latitude, longitude: crumb.longitude),
                    radius: kRadiusMeters,
                    id: crumb.id,
                    title: crumb.title,
                    subtitle: "Radius: \(kRadiusMeters)m - On Entry")
            }
            
            self.overlays.value = self.annotations.value.map {
                return MKCircle(centerCoordinate: $0.coordinate, radius: $0.radius)
            }
            

        } catch let error as NSError {
            showSimpleAlertWithTitle("Error loading data!", message: error.localizedDescription, viewController: (UIApplication.sharedApplication().keyWindow?.rootViewController)!)
        }
        
    }
    
    func getCrumbImage() -> SignalProducer<UIImage?, NoError> {
        return SignalProducer.empty
    }
    
}