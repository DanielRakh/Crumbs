//
//  CBCameraController .swift
//  Crumbs
//
//  Created by Daniel on 11/13/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import UIKit
import CoreLocation


let kSavedItemsKey = "savedItems"


class CBCameraController: UIViewController, UINavigationControllerDelegate {
    
    
    let locationManager = CLLocationManager()
    let locations = [CLLocation]()
    var crumbs = [CBCrumb]()


    @IBAction func showCameraButtonDidTouch(sender: AnyObject) {
        guard let cameraController = openCamera() else {
            print("Throw an error here")
            return
        }
        presentViewController(cameraController, animated: true, completion: nil)
        
    }
    
    @IBAction func getExistingCrumbsButtonDidTouch(sender: AnyObject) {
        getCrumbs { result in
            self.saveAllCrumbs(result)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        loadAllCrumbs()
        
        if crumbs.count > 0 {
            
            for crumb in self.crumbs {
                startMonitoringCrumb(crumb)
            }
            
        }
        
       
        
        
    }
    
    func regionWithGeotification(crumb: CBCrumb) -> CLCircularRegion {
        
        let coordinate = CLLocationCoordinate2D(latitude: Double(crumb.latitude)!, longitude: Double(crumb.longitude)!)
        
        let region = CLCircularRegion(center:coordinate, radius: 10, identifier: "\(crumb.crumbId)")
        
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        return region
    }
    
    
    func startMonitoringCrumb(crumb: CBCrumb) {
        // 1
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            presentAlertWithMessage("Geofencing is not supported on this device!")
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            presentAlertWithMessage("Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        // 3
        let region = regionWithGeotification(crumb)
        // 4
        locationManager.startMonitoringForRegion(region)
    }
    
    
    func stopMonitoringGeotification(crumb: CBCrumb) {
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == "\(crumb.crumbId)" {
                    locationManager.stopMonitoringForRegion(circularRegion)
                }
            }
        }
    }
    
    
    
    func getCrumbs(completion: (result: [CBCrumb]) -> Void) {
        // Hit up network
        
        //TODO: Get URL
        let url = NSURL(string:"https://crumbs-app.herokuapp.com/posts")!
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            guard error == nil else {
                self.presentAlertWithMessage(error!.localizedDescription)
                return
            }
            
            guard (response as? NSHTTPURLResponse)?.statusCode == 200 else {
                let statusCode = (response as? NSHTTPURLResponse)?.statusCode
                self.presentAlertWithMessage("\(statusCode)")
                return
            }
            
            do {
                
                let jsonCrumbs = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [AnyObject]
                let crumbs = self.convertData(jsonCrumbs)
                completion(result: crumbs)

                
            } catch let error as NSError {
            
                self.presentAlertWithMessage(error.localizedDescription)
            }
            
            }.resume()
        
        
        // Create Crumbs Objects
        // Convert them to CLLocationObjects
        // Set up geo fence
        // Add alert whenever you enter that fence.
        
        
    }
    
    
    func convertData(data:[AnyObject]) -> [CBCrumb] {
        
        return data.flatMap { dict in
            
            return CBCrumb(
                userId: dict["user_id"] as! Int,
                crumbId: dict["id"] as! Int,
                imageURL: dict["image_url"] as! String,
                longitude: dict["longitude"] as! String,
                latitude: dict["latitude"] as! String)
        }
        
    }
    


    
    func presentAlertWithMessage(message:String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert) // 7
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (alert: UIAlertAction!) -> Void in
            print("You pressed button OK")
        }
        alert.addAction(defaultAction)
        presentViewController(alert, animated: true, completion:nil)
    }
    
    
    
    func openCamera() -> UIImagePickerController? {
        
        guard UIImagePickerController.isSourceTypeAvailable(.Camera) else {
            print("No camera available bruh!")
            return nil
        }
        
        let cameraImagePicker = UIImagePickerController()
        cameraImagePicker.sourceType = .Camera
        cameraImagePicker.cameraCaptureMode = .Photo
        cameraImagePicker.allowsEditing = false
        cameraImagePicker.delegate = self
        
        return cameraImagePicker
    }
    
    
    //Helpers
    
    func loadAllCrumbs() {
        self.crumbs = []

        if let savedItems = NSUserDefaults.standardUserDefaults().arrayForKey(kSavedItemsKey) {
            for savedItem in savedItems {
                if let crumb = NSKeyedUnarchiver.unarchiveObjectWithData(savedItem as! NSData) as? CBCrumb {
                    self.crumbs.append(crumb)
                }
            }
        }
    }
    
    func saveAllCrumbs(crumbs:[CBCrumb]) {
        let items = NSMutableArray()
        for crumb in crumbs {
            let item = NSKeyedArchiver.archivedDataWithRootObject(crumb)
            items.addObject(item)
        }
        NSUserDefaults.standardUserDefaults().setObject(items, forKey: kSavedItemsKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
}


extension CBCameraController : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region?.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")

    }
    
    
}


















extension CBCameraController :  UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //        let crumb = CBCrumb(user_id: "User ID", imageURL:"fakeurl.com", longitude:3043204320432, latitude:2340320432);
        //
        //        picker.presentingViewController!.dismissViewControllerAnimated(true) {
        //            print("Dismissed")
        //        }
    }
}








