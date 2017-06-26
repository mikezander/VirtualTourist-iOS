//
//  Photo+CoreDataClass.swift
//  VirtualTourist-iOS
//
//  Created by Michael Alexander on 6/26/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

//@objc(Photo)
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
