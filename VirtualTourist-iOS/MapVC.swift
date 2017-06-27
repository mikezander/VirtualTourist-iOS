//
//  MapVC.swift
//  VirtualTourist-iOS
//
//  Created by Michael Alexander on 6/26/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class MapVC: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
   

    lazy var fetchedResultsController: NSFetchedResultsController <NSFetchRequestResult> = {
        
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "latitude", ascending: true),
                              NSSortDescriptor(key: "longitude", ascending: true)]
        
        // Create the FetchedResultsController
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMapView()
        self.mapView.delegate = self
        
        var objects: [Any]?
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let _ = delegate.stack

        do {
            try fetchedResultsController.performFetch()
            
            objects = (fetchedResultsController.sections?[0].objects)!
        } catch let err {
            print(err)
        }
        
        addAnnotationstoMap(objects: objects)
        
    }
  
 
    @IBAction func addPinTapped(_ sender: UILongPressGestureRecognizer) {
    
        if sender.state == UIGestureRecognizerState.ended {
            let location = sender.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let stack = delegate.stack
            
            let pin = Pin(lat: coordinate.latitude, long: coordinate.longitude, context: stack.context)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            // add pin to map
            mapView.addAnnotation(annotation)
            
            stack.save()
            
            // fetch photos
           /*
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PinVC") as! PinVC
            
            // Creating a navigation controller with viewController at the root of the navigation stack.
            let navController = UINavigationController(rootViewController: viewController)
            
            self.present(navController, animated:true, completion: nil)
            
           // stack.fetchPhotos(pin: pin) {
           //     stack.save()
           // }
 */
        }
    }
}

extension MapVC: MKMapViewDelegate {
    
    public func addAnnotationstoMap(objects: [Any]?) {
        
        if let objects = objects {
            for object in objects {
                guard let pin = object as? Pin else {
                    return
                }
                let lat = CLLocationDegrees(pin.latitude)
                let long = CLLocationDegrees(pin.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
            }
            
        }
    }
    
    fileprivate func loadMapView() {
        let span = MKCoordinateSpanMake(UserDefaults.standard.double(forKey: "latitudeDeltaKey"), UserDefaults.standard.double(forKey: "longitudeDeltaKey"))
        
        let location = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitudeKey"), longitude: UserDefaults.standard.double(forKey: "longitudeKey"))
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mapView.setRegion(region, animated: true)
        
       
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "latitudeKey")
        UserDefaults.standard.set(mapView.region.center.longitude, forKey: "longitudeKey")
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: "latitudeDeltaKey")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: "longitudeDeltaKey")
        UserDefaults.standard.synchronize()
    }
    
   

}
