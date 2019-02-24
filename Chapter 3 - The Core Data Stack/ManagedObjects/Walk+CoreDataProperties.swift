//
//  Walk+CoreDataProperties.swift
//  Dog Walk
//
//  Created by npiparav on 24/02/19.
//  Copyright © 2019 NitWare. All rights reserved.
//
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var dog: Dog?

}
