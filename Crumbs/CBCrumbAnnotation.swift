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
    let id: Int
    var image:UIImage?
    var imageURL:String?
    var title: String?
    var subtitle: String?
    
    
    init(coordinate: CLLocationCoordinate2D, radius:CLLocationDistance, id:Int, image:UIImage?, imageURL:String?, title:String?, subtitle:String?) {
        self.coordinate = coordinate
        self.radius = radius
        self.id = id
        self.image = image
        self.imageURL = imageURL
        self.title = title
        self.subtitle = subtitle
    
        super.init()
    }
    
}

