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
        
        loadMapViewDefaults()
        self.mapView.delegate = self
        
        var objects: [Any]?

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
            
            _ = Pin(lat: coordinate.latitude, long: coordinate.longitude, isDownloaded: false, context: stack.context)

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            // add pin to map
            mapView.addAnnotation(annotation)
 
            stack.save()
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
    
    fileprivate func loadMapViewDefaults() {
        let span = MKCoordinateSpanMake(UserDefaults.standard.double(forKey: "latitudeDeltaKey"), UserDefaults.standard.double(forKey: "longitudeDeltaKey"))
        
        let location = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "latitudeKey"), longitude: UserDefaults.standard.double(forKey: "longitudeKey"))
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
        
        let latPredicate = NSPredicate(format: "latitude == %lf", (view.annotation?.coordinate.latitude)!)
        let longPredicate = NSPredicate(format: "longitude == %lf", (view.annotation?.coordinate.longitude)!)
        let andRequest = NSCompoundPredicate(type: .and, subpredicates: [latPredicate, longPredicate])
        
        fetchedResultsController.fetchRequest.predicate = andRequest
        
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            print(err)
        }

        let pin = fetchedResultsController.sections?[0].objects?[0] as! Pin
      
        moveToPhotosVC(fetchcontroller: fetchedResultsController, pin: pin, view: view)
    }
    
    
    public func moveToPhotosVC(fetchcontroller: NSFetchedResultsController <NSFetchRequestResult>, pin: Pin, view: MKAnnotationView) {

        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        let fr = NSFetchRequest<Photo>(entityName: "Photo")
        
        fr.sortDescriptors = []

        let pred = NSPredicate(format: "pin = %@", pin)
        
        fr.predicate = pred
        
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil , cacheName: nil)
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier:"PhotosVC") as! PhotosVC
        
        do {
            try fc.performFetch()
        } catch let err  {
            print(err)
        }
        
        
        // inject into PhotosVC
        controller.fetchedResultController = fc
        controller.pin = pin

        self.navigationController?.pushViewController(controller, animated: true)
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        UserDefaults.standard.set(mapView.region.center.latitude, forKey: "latitudeKey")
        UserDefaults.standard.set(mapView.region.center.longitude, forKey: "longitudeKey")
        UserDefaults.standard.set(mapView.region.span.latitudeDelta, forKey: "latitudeDeltaKey")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta, forKey: "longitudeDeltaKey")
        UserDefaults.standard.synchronize()
    }

}
