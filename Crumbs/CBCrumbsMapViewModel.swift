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


class CBCrumbsMapViewModel : NSObject, CBCrumbsMapViewModeling {
    
    var crumbAnnotations:AnyProperty<[CBCrumbAnnotation]> {
        return AnyProperty(annotations)
    }
    
    var crumbOverlays:AnyProperty<[MKOverlay]> {
        return AnyProperty(overlays)
    }
    
    private var crumbImage:UIImage?
    
    
    private let networkService: CBNetworking
    
    private let annotations = MutableProperty<[CBCrumbAnnotation]>([CBCrumbAnnotation]())
    private let overlays = MutableProperty<[MKOverlay]>([MKOverlay]())
    
    
    private let kRadiusMeters:CLLocationDistance = 10.0
    
    
    
    init(networking: CBNetworking) {
        networkService = networking
        super.init()
    }
    
    
    func fetchAnnotations() {
        
        do {
            
            let realm = try Realm()
            let annotations = realm.objects(CBCrumbResponseEntity).map { crumb in
                
                return CBCrumbAnnotation(
                    coordinate:
                    CLLocationCoordinate2D(latitude: crumb.latitude, longitude: crumb.longitude),
                    radius: self.kRadiusMeters,
                    id: crumb.id,
                    image: nil,
                    imageURL: crumb.imageURL,
                    title: crumb.title,
                    subtitle: "Radius: \(self.kRadiusMeters)m - On Entry")
                
                }

            
            // Get [CBCrumbResponseEntity]...for each one get an image.....once you got the image....create an annotation....collectAll and return
            
            self.annotations <~ passCrumbs(arr)
                .flatMap(.Concat, transform: getCrumbImage)
                .flatMap(.Concat, transform: createAnnotations).collect()
            
            
            self.overlays.value = self.annotations.value.map {
                return MKCircle(centerCoordinate: $0.coordinate, radius: $0.radius)
            }
            

        } catch let error as NSError {
            showSimpleAlertWithTitle("Error loading data!", message: error.localizedDescription, viewController: (UIApplication.sharedApplication().keyWindow?.rootViewController)!)
        }
        
    }
    
    
    private func passCrumbs(crumbs:[CBCrumbResponseEntity]) -> SignalProducer<CBCrumbResponseEntity, NoError> {
        return SignalProducer {observer , disposable in
            
           _ =  crumbs.map { crumb in
                observer.sendNext(crumb)
                observer.sendCompleted()
            }
        }
    }
    
    
//    private func getCrumbsFromRealm(realm:Realm) -> SignalProducer<CBCrumbResponseEntity,NoError> {
//        
//        
//        return SignalProducer { observer, disposable in
//            
//            _ = arr.map { entity in
//                observer.sendNext(entity)
//                observer.sendCompleted()
//            }
//        }
//    }
    
    
    
    

    private func createAnnotations(crumbImage:UIImage?, crumb:CBCrumbResponseEntity) -> SignalProducer<CBCrumbAnnotation,NoError> {
        return SignalProducer {observer, disposable in
            
            let annotation = CBCrumbAnnotation(
                coordinate:
                CLLocationCoordinate2D(latitude: crumb.latitude, longitude: crumb.longitude),
                radius: self.kRadiusMeters,
                id: crumb.id,
                image: crumbImage,
                title: crumb.title,
                subtitle: "Radius: \(self.kRadiusMeters)m - On Entry")
            
            observer.sendNext(annotation)
            observer.sendCompleted()
        
        }
    }
    
    
    
    private func getCrumbImage(crumb:CBCrumbResponseEntity) -> SignalProducer<(UIImage?, CBCrumbResponseEntity),  NoError> {
        
        return SignalProducer {observer, disposable in
            
            self.networkService.producerToRequestImage(crumb.imageURL!).startOn(QueueScheduler.mainQueueScheduler)
                .takeUntil(self.racutil_willDeallocProducer)
                .on(next: {
                    observer.sendNext(($0, crumb))
                    observer.sendCompleted()
                }).start()
//                .map { $0 as UIImage? }
//                .flatMapError { _ in SignalProducer<UIImage?, NoError>(value: nil) }
        }
        
//        let imageProducer = networkService.producerToRequestImage(crumb.imageURL!).startOn(QueueScheduler.mainQueueScheduler)
//                .takeUntil(self.racutil_willDeallocProducer)
//                .on(next: { self.crumbImage = $0 })
//                .map { $0 as UIImage? }
//                .flatMapError { _ in SignalProducer<UIImage?, NoError>(value: nil) }
//            .wait()
//            
//            return SignalProducer(value: nil)
//                .concat(imageProducer)
//                .observeOn(UIScheduler())
//        }
    }

}