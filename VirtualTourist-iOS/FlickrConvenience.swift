//
//  FlickrConvenience.swift
//  VirtualTourist-iOS
//
//  Created by Michael Alexander on 6/28/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension FlickrClient{

    
    public func getPhotosForPin(pin: Pin){
       
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        FlickrClient.sharedInstance().taskForGETPhotos(latitude: pin.latitude, longitude: pin.longitude){(success, data, error) in
            
            

            if let data = data{
                
                for each in data{
                    
                    let imageUrl = each[Constants.FlickrParameterValues.MediumURL] as! String
                    
                    let photo = Photo(image: nil, imageURL: imageUrl, context: stack.context)
                    
                    pin.addToPhotos(photo)
                   
                    stack.save()
                    
               }
               
            }
            pin.isDownloaded = true
            
            
        }
        
      
    }

    
    public func loadPhotoFromURL(imagePath: String, completionHandler: @escaping (_ imageData: Data?, _ error: String?) -> Void){
        let session = URLSession.shared
        let imageURL = URL(string: imagePath)
        let request = URLRequest(url: imageURL! as URL)
        
        let task = session.dataTask(with: request as URLRequest){ data, response, error in
            guard error == nil else{ completionHandler(nil, "Error downloading image - \(error)")
                return
            }
            
            completionHandler(data,nil)
        }
    
        task.resume()
    
    }

}
