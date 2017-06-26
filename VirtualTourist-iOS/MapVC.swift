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

class MapVC: UIViewController, MKMapViewDelegate{

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
        var objects: [Any]?
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let _ = delegate.stack
       
        self.mapView.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            
            objects = (fetchedResultsController.sections?[0].objects)!
        } catch let err {
            print(err)
        }
        
        addAnnotationstoMap(objects: objects)
        
    }


}

extension MapVC {
    
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
}
