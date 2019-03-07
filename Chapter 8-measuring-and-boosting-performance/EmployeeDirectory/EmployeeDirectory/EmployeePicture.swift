//
//  EmployeePicture.swift
//  EmployeeDirectory
//
//  Created by npiparav on 07/03/19.
//  Copyright © 2019 Razeware. All rights reserved.
//

import Foundation
import CoreData

class EmployeePicture: NSManagedObject {

  @NSManaged var picture: Data
  @NSManaged var employee: EmployeeDirectory.Employee
  
}
