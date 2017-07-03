//
//  FlickrConvenience.swift
//  VirtualTourist-iOS
//
//  Created by Michael Alexander on 7/2/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation
import UIKit
extension FlickrClient{

    public func getPhotosForPin(pin: Pin){
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack


        DispatchQueue.main.async {
            FlickrClient.sharedInstance().taskForGETPhotos(latitude: pin.latitude, longitude: pin.longitude){(success, data, error) in

            if let data = data{
                
                for each in data{
                    
                    let imageUrl = each[Constants.FlickrParameterValues.MediumURL] as! String
                    
                   
                        let photo = Photo(imageData: nil, imageURL: imageUrl, context: stack.context)
                    
                        pin.addToPhotos(photo)
                    
                    
                        stack.save()
                    
                }
                
            }
            
            pin.isDownloaded = true
            
        }
        
    }
    } //end DispatchQueue.main.async
}
