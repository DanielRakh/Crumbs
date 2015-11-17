//
//  RACUtil.swift
//  Crumbs
//
//  Created by Daniel on 11/17/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import Foundation
import ReactiveCocoa
import UIKit

internal extension NSObject {
    internal var racutil_willDeallocProducer: SignalProducer<(), NoError>  {
        return self.rac_willDeallocSignal()
            .toSignalProducer()
            .map { _ in }
            .flatMapError { _ in SignalProducer(value: ()) }
    }
}


internal extension UITableViewCell {
    internal var racutil_prepareForReuseProducer: SignalProducer<(), NoError>  {
        return self.rac_prepareForReuseSignal
            .toSignalProducer()
            .map { _ in }
            .flatMapError { _ in SignalProducer(value: ()) }
    }
}