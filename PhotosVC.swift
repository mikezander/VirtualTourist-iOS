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

class PhotosVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    var pin: Pin!
    var fetchedResultController: NSFetchedResultsController <Photo>!

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionBtn: UIButton!
    
    fileprivate let cellsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        fetchedResultController.delegate = self
        photoCollectionView.allowsMultipleSelection = true
        
        addPinToView()

        self.photoCollectionView.reloadData()
        
      
 
    }
    @IBAction func newCollectionPressed(_ sender: Any) {
        deletePhotoCollection()
    }
    
    public func deletePhotoCollection() {
        for each in fetchedResultController.fetchedObjects!{
            fetchedResultController.managedObjectContext.delete(each)
            do {
                try  fetchedResultController.managedObjectContext.save()
            } catch {
                print("There was an error saving")
            }
        }
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
    
    public func noPhotosFoundLabel(){
        let label = UILabel()
        label.text = "No photos found for this location."
        label.textAlignment = .center
        label.frame = CGRect(x:self.view.frame.size.width/10,y: self.view.frame.size.height/2,width: 300,height: 60)
        
        self.view.addSubview(label)
    }

    //MARK: Collection view delegate & data source methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let fc = fetchedResultController {
            return (fc.sections?.count)!
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let fc = fetchedResultController {
            return fc.sections![section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
 
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        let photo = fetchedResultController!.object(at: indexPath)
        
        if let imageData = photo.imageData {

            let image = UIImage(data: imageData as Data)
    
            cell.photoImageView.image = image
        }else{
            performUIUpdatesOnMain { cell.activityIndicator.startAnimating() }
            
            FlickrClient.sharedInstance().loadPhotoFromURL(imagePath: photo.imageURL!) { (imageData, error) in
                guard error == nil else {
                    print("Error loading photo from URL-\(error)"); return}
                
                photo.imageData = imageData as NSData?
                stack.save()
                self.performUIUpdatesOnMain {
                   
                    cell.activityIndicator.isHidden = true
                    cell.activityIndicator.stopAnimating()
                }
                
            }
        }
        
        
        return cell
            
        }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        fetchedResultController.managedObjectContext.delete(fetchedResultController.object(at: indexPath))
        
        do {
            try  fetchedResultController.managedObjectContext.save()
        } catch {
            print("Error saving photos")
        }
        
    }
    
}

extension PhotosVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalPadding = sectionInsets.left * (cellsPerRow + 1)
        let availableWidth = view.frame.width - totalPadding
        let widthPerItem = availableWidth / cellsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

extension PhotosVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type.rawValue == 1 {
            performUIUpdatesOnMain {
                self.photoCollectionView.reloadData()
            }
        }
        if type.rawValue == 2 {
            performUIUpdatesOnMain {
                self.photoCollectionView.reloadData()
            }
        }
        if type.rawValue == 4 {
            performUIUpdatesOnMain {
                self.photoCollectionView.reloadData()
            }
        }
        
    }
    
}






