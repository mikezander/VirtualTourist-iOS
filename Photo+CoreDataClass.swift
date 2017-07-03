//
//  Photo+CoreDataClass.swift
//  VirtualTourist-iOS
//
//  Created by Michael Alexander on 7/3/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    convenience init(imageData: NSData?,imageURL: String?, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context){
            self.init(entity: ent, insertInto: context)
            self.imageData = imageData
            self.imageURL = imageURL
        }else{
            fatalError("Uable to find entity name")
        }
    }
}
