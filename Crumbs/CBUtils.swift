//
//  CBUtils.swift
//  Crumbs
//
//  Created by Daniel on 11/20/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import UIKit

func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alert.addAction(action)
    viewController.presentViewController(alert, animated: true, completion: nil)
}



let firstBlue = UIColor(red:0.411, green:0.402 , blue:1.000, alpha: 1.0)
let secondBlue = UIColor(red:0.046, green:0.339 , blue:0.730, alpha: 1.0)

func pulseViewWithColors(view:UIView, firstColor:UIColor? = firstBlue , secondColor:UIColor? = secondBlue) {
    UIView.animateKeyframesWithDuration(2.0, delay: 0.0, options: [UIViewKeyframeAnimationOptions.Repeat, UIViewKeyframeAnimationOptions.Autoreverse], animations: { () -> Void in
        
        UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
            view.backgroundColor = firstColor!
        })
        
        UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
            view.backgroundColor = secondColor!
        })
        
        }, completion: nil)
}


//[UIView animateKeyframesWithDuration:2.0 delay:0.0 options:UIViewKeyframeAnimationOptionAutoreverse | UIViewKeyframeAnimationOptionRepeat animations:^{
//    [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
//    someView.backgroundColor = [UIColor redColor];
//    }];
//    [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
//    someView.backgroundColor = [UIColor whiteColor];
//    }];
//    } completion:nil];