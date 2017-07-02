//
//  Photo+CoreDataProperties.swift
//  VirtualTourist-iOS
//
//  Created by Michael Alexander on 7/1/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var imageURL: String?
    @NSManaged public var pin: Pin?

}
