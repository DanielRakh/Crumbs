//
//  CBCrumbAnnotation.swift
//  Crumbs
//
//  Created by Daniel on 11/20/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import MapKit

class CBCrumbAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let radius: CLLocationDistance
    
    var title: String?
    var image: UIImage?
    var subtitle: String?
    
    
    init(coordinate: CLLocationCoordinate2D, radius:CLLocationDistance, image:UIImage?, title:String?, subtitle:String?) {
        self.coordinate = coordinate
        self.radius = radius
        self.title = title
        self.subtitle = subtitle
        self.image = image
        
        super.init()
    }
    
}

