//
//  PinVC.swift
//  VirtualTourist-iOS
//
//  Created by Michael Alexander on 6/26/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import CoreData

class PhotosVC: UIViewController{

    var pin: Pin! 
    var fetchedResultController: NSFetchedResultsController <Photo>!

    @IBOutlet weak var mapView: MKMapView!
 
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPinToView()
        
       /* if !(pin.isDownloaded){
        
            if !(FlickrClient.sharedInstance().getPhotosForPin(pin: pin)){
                
                performUIUpdatesOnMain {
                    let label = UILabel()
                    label.frame = CGRect(x:self.view.frame.size.width/2,y: 30,width: 300,height: 60)
                    label.text = "No photos found for this location."
                }
                
                print("photots found!")
            }
            
 
            
        }else{
        
            
        }
*/
       
    }
       
    public func addPinToView() {
        let lat = CLLocationDegrees(pin.latitude)
        let long = CLLocationDegrees(pin.longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
