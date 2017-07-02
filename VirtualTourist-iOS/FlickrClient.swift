//
//  FlickrClient.swift
//  VirtualTourist-iOS
//
//  Created by Michael Alexander on 6/22/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation

class FlickrClient{

    let session = URLSession.shared
   
    func taskForGETPhotos(latitude: Double, longitude: Double, _ completionHandlerForGET: @escaping (_ success: Bool, _ data: [[String: AnyObject]]?, _ error: String?) -> Void) {
        
         let randomNumber = UInt64(arc4random_uniform(50) + 1)
        
        let methodParameters = [Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
                                Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
                                Constants.FlickrParameterKeys.Latitude: latitude,
                                Constants.FlickrParameterKeys.Longitude: longitude,
                                Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.JSONFormat,
                                Constants.FlickrParameterKeys.NoJSONCallBack: Constants.FlickrParameterValues.DisableJSONCallback,
                                Constants.FlickrParameterKeys.BBox: returnBbox(latitude: latitude, longitude: longitude),
                                Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
                                Constants.FlickrParameterKeys.PerPage: Constants.FlickrParameterValues.PerPageLimit,
                                Constants.FlickrParameterKeys.Page: randomNumber] as [String : Any]

        let urlString = Constants.Flickr.APIScheme +
                        Constants.Flickr.APIHost +
                        Constants.Flickr.APIPath +
            escapedParameters(methodParameters as [String:AnyObject])
        
        let url = URL(string: urlString)!
        // Configure request with URL
        let request = NSMutableURLRequest(url: url)
        // Make the request
        let task = session.dataTask(with: request as URLRequest){(data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(false, nil , String(describing:NSError(domain: "taskForGETPhotos", code: 1, userInfo: userInfo)))
            }
            
            /* GUARD: Was there an error? */
            guard error == nil else {
                sendError(error: "There was an error with your request: \(error?.localizedDescription)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(error: "No data was returned by the request!")
                return
            }
            
            // parse JSON data into useable foundation objects
            var parsedResult: [String:AnyObject]! = nil
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
            } catch {
                print("Could not parse JSON data")
                
            }
            
            guard let photoDictionary = parsedResult[Constants.ResponseKeys.Photos] as? [String:AnyObject], let photoArray = photoDictionary[Constants.ResponseKeys.Photo] as? [[String:AnyObject]] else {
                return
            }

            completionHandlerForGET(true, photoArray, nil)
   
        }
    
        task.resume()
 
    }

    class func sharedInstance() -> FlickrClient {
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        return Singleton.sharedInstance
    }
    
}

extension FlickrClient {
    // adds neccessary characters to url
    public func escapedParameters(_ parameters: [String:AnyObject]) -> String {

        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure that it is a string value
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
                
            }
            
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }

    public func returnBbox(latitude: Double, longitude: Double) -> String {
        
        let longitudeMinimum = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
        let latitudeMinimum = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
        let longitudeMaximum = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
        let latitudeMaximum = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
    
        return "\(longitudeMinimum),\(latitudeMinimum),\(longitudeMaximum),\(latitudeMaximum)"

    }
}
