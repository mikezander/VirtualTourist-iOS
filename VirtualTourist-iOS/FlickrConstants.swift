//
//  FlickrConstants.swift
//  VirtualTourist-iOS
//
//  Created by Michael Alexander on 6/22/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation

extension FlickrClient{

    struct Constants {
 
        struct Flickr {

            static let APIScheme = "https://"
            static let APIHost = "api.flickr.com"
            static let APIPath = "/services/rest/"
            
            static let SearchBBoxHalfWidth = 0.3
            static let SearchBBoxHalfHeight = 0.3
            static let SearchLatRange = (-90.0, 90.0)
            static let SearchLonRange = (-180.0, 180.0)
            
        }
        
        struct FlickrParameterKeys {
            static let Method = "method"
            static let APIKey = "api_key"
            static let Latitude = "lat"
            static let Longitude = "long"
            static let Radius = "radius"
            static let Format = "format"
            static let NoJSONCallBack = "nojsoncallback"
            static let BBox = "bbox"
            static let Extras = "extras"
            static let PerPage = "per_page"
            static let Page = "page"
        }
        
        struct FlickrParameterValues {
            static let APIKey = "397f1a17902d247b1f7f703c34b06030"
            static let SearchMethod = "flickr.photos.search"
            static let RadiusAmount = "3"
            static let JSONFormat = "json"
            static let DisableJSONCallback = "1"
            static let MediumURL = "url_m"
            static let PerPageLimit = 21
        }
        
        struct ResponseKeys {
            static let Status = "stat"
            static let Photos = "photos"
            static let Photo = "photo"
            static let Title = "title"
            static let MediumURL = "url_m"
        }
        
     
        struct ResponseValues {
            static let OKStatus = "ok"
        }
    }


}
