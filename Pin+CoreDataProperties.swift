//
//  Pin+CoreDataProperties.swift
//  VirtualTourist-iOS
//
//  Created by Michael Alexander on 6/28/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin");
    }

    @NSManaged public var isDownloaded: Bool
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var photos: Photo?

}
