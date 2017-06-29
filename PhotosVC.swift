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

    var pin: Pin?
    var fetchedResultController: NSFetchedResultsController <Photo>!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
    }
    
    
}
