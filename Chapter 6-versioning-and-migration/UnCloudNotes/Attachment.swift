//
//  Attachment.swift
//  UnCloudNotes
//
//  Created by npiparav on 06/03/19.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Attachment: NSManagedObject {
  
  @NSManaged var dateCreated: Date
  @NSManaged var image: UIImage?
  
  
  //MARK: RelantionShip
  @NSManaged var note: Note?
  
}
