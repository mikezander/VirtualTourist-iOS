
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

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionBtn: UIButton!
    
    fileprivate let cellsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var noPhotosLabel = UILabel()
    
    lazy var fetchedResultsController: NSFetchedResultsController <Photo> = {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fr.sortDescriptors = []
        let predicate = NSPredicate(format: "pin = %@", self.pin)
        fr.predicate = predicate
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        return fetchedResultsController as! NSFetchedResultsController<Photo>
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.allowsMultipleSelection = true
        
        addPinToView()
        
        performUIUpdatesOnMain { self.noPhotosLabel = self.configNoPhotosLabel()}
       
        fetchPhotos()

        performUIUpdatesOnMain { self.photoCollectionView.reloadData() }
        
        photoCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.old, context: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       photoCollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observedObject = object as? UICollectionView, observedObject == photoCollectionView {
            //collection view is done loading
            performUIUpdatesOnMain {
                self.newCollectionBtn.isEnabled = true
                
            }
        }
    }

    func fetchPhotos() {
        do {
            try fetchedResultsController.performFetch()
           
        } catch {
            print("Unable to retrieve Photos\nPlease try again.")
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
    
    public func configNoPhotosLabel()-> UILabel{
        let label = UILabel()
        label.text = "No photos found for this location."
        label.isHidden = true
        label.frame = CGRect(x:self.view.frame.size.width/10,y: self.view.frame.size.height/2,width: 300,height: 60)
        
        self.view.addSubview(label)
        return label
    }
   
    
    public func deletePhotoCollection() {
        for index in fetchedResultsController.fetchedObjects!{
            fetchedResultsController.managedObjectContext.delete(index as NSManagedObject)
            do {
                try  fetchedResultsController.managedObjectContext.save()
            } catch {
                print("There was an error saving")
            }
        }
    }

    @IBAction func newCollectionPressed(_ sender: Any) {
 
        deletePhotoCollection()
        
        pin.isDownloaded = false
        
        FlickrClient.sharedInstance().getPhotosForPin(pin: pin)
        
        
        pin.isDownloaded = true
        
        print(pin.isDownloaded)
        performUIUpdatesOnMain {
            self.photoCollectionView.reloadData()
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sections = fetchedResultsController.sections![section]
        
        if sections.numberOfObjects == 0{
            performUIUpdatesOnMain { self.noPhotosLabel.isHidden = false }
        }else{
            performUIUpdatesOnMain { self.noPhotosLabel.isHidden = true }
        }
        
        return sections.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
 
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        
        let photo = fetchedResultsController.object(at: indexPath)

        if let imageData = photo.imageData {

            let image = UIImage(data: imageData as Data)
            
            performUIUpdatesOnMain {
                cell.placeHolderView.isHidden = true
                cell.photoImageView.image = image
            }
        
        }else{
            performUIUpdatesOnMain {
                self.newCollectionBtn.isEnabled = false
                cell.activityIndicator.startAnimating()
                cell.placeHolderView.isHidden = false
            }
            
            FlickrClient.sharedInstance().loadPhotoFromURL(imagePath: photo.imageURL!) { (imageData, error) in
                guard error == nil else {
                    print("Error loading photo from URL-\(error)"); return}
                
                 photo.imageData = imageData as NSData?
                 stack.save()
                
                self.performUIUpdatesOnMain {
                   
                    cell.activityIndicator.hidesWhenStopped = true
                    cell.activityIndicator.stopAnimating()
                }
    
            }
            
        }

        return cell
        
        }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fetchedResultsController.managedObjectContext.delete(fetchedResultsController.object(at: indexPath) as NSManagedObject)
        
        do {
            try  fetchedResultsController.managedObjectContext.save()
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






