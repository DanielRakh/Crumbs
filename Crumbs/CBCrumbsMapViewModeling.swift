//
//  CBCrumbsMapViewModeling.swift
//  Crumbs
//
//  Created by Daniel on 11/21/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit


protocol CBCrumbsMapViewModeling {
    
    var crumbAnnotations:AnyProperty<[CBCrumbAnnotation]> { get }
    var crumbOverlays:AnyProperty<[MKOverlay]> { get }

    
    func fetchAnnotations()
//    func getCrumbImage() -> SignalProducer<UIImage?, NoError>
    
}