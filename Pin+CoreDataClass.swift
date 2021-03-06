//
//  Pin+CoreDataClass.swift
//  VirtualTourist-iOS
//
//  Created by Michael Alexander on 7/3/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation
import CoreData


public class Pin: NSManagedObject {
    convenience init(lat: Double, long: Double, isDownloaded: Bool, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context){
            self.init(entity: ent, insertInto: context)
            self.latitude = lat
            self.longitude = long
            self.isDownloaded = isDownloaded
        }else{
            fatalError("Uable to find entity name")
        }
    }
}
