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

    
    func taskForGETMethod(parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) -> URLSessionDataTask {

        // Configure request with URL
        let request = NSMutableURLRequest(url: buildFlickrURL(parameters))
        // Make the request
        let task = session.dataTask(with: request as URLRequest){(data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
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
            
            
          self.convertJSONDataWithCompletion(data, completionHandler: completionHandlerForGET)
            
            
        }
    
        task.resume()
    
        return task
  
    }
    
    private func convertJSONDataWithCompletion(_ data: Data, completionHandler: (_ result: [String:AnyObject]?, _ error: NSError?) -> Void){
        
        var parsedResult: [String:AnyObject]! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            return
        }
        
        completionHandler(parsedResult, nil)
    }
    
    
    
    private func buildFlickrURL(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    
}
