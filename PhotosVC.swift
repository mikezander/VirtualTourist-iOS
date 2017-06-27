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

    var pin: Pin? = nil
    var fetchedResultController: NSFetchedResultsController <Photo>!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(pin?.latitude)
        print(pin?.longitude)
    }
}
