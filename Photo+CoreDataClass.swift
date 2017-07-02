//
//  Photo+CoreDataClass.swift
//  VirtualTourist-iOS
//
//  Created by Michael Alexander on 7/1/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    convenience init(image: NSData?, imageURL: String?,context: NSManagedObjectContext){
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context){
            self.init(entity: ent, insertInto: context)
            self.imageURL = imageURL
            self.imageData = image
        }else{
            fatalError("Uable to find entity name")
        }
    }
}
