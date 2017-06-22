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
    
         static let MaxItemsPerCollection = 21
        
        struct Flickr {

            static let APIScheme = "https"
            static let APIHost = "api.flickr.com"
            static let APIPath = "/services/rest"
            
            static let SearchBBoxHalfWidth = 0.3
            static let SearchBBoxHalfHeight = 0.3
            static let SearchLatRange = (-90.0, 90.0)
            static let SearchLonRange = (-180.0, 180.0)
            
        }
        
        struct FlickrParameterKeys {
            static let Method = "method"
            static let APIKey = "api_key"
            static let Latitude = "lat"
            static let Longitude = "lon"
            static let Radius = "radius"
            static let Format = "format"
            static let NoJSONCallBack = "nojsoncallback"
            static let Extras = "extras"
            static let PerPage = "per_page"
            static let Page = "page"
        }
        
        struct FlickrParameterValues {
            static let APIKey = "28af64af1df718d65df6e2e7b26414cb"
            static let APISectret = "4e4306259905e854"
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
