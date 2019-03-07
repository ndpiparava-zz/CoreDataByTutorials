//
//  CamperServiceTests.swift
//  CampgroundManagerTests
//
//  Created by npiparav on 07/03/19.
//  Copyright © 2019 Razeware. All rights reserved.
//

import XCTest
import CampgroundManager


class CamperServiceTests: XCTestCase {
  
  
    //MARK: Properties
    var camperService: CamperService!
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
      
      coreDataStack = TestCoreDataStack()
      camperService = CamperService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
      camperService = nil
      coreDataStack = nil
    }
  
  func testRootContextIsSavedAfterAddingCamper() {
    
    //1
    let derivedContext = coreDataStack.newDerivedContext()
    camperService = CamperService(managedObjectContext: derivedContext, coreDataStack:coreDataStack )
    
    //2
    expectation(forNotification: NSNotification.Name.NSManagedObjectContextDidSave.rawValue, object: coreDataStack.mainContext) { (notification) -> Bool in
      return true
    }
    
    //3
    let camper = camperService.addCamper("Bacon Lover", phoneNumber: "910-543-9000")
    XCTAssertNotNil(camper)
    
    //4
    waitForExpectations(timeout: 2.0) { error  in
      XCTAssertNil(error, "Save did not occur")
    }
  }
    
  func testAddCamper() {
    let camper = camperService.addCamper("Bacon Lover", phoneNumber: "910-543-9000")
    XCTAssertNotNil(camper, "Camper should not be nil")
    XCTAssertTrue(camper?.fullName == "Bacon Lover")
    XCTAssertTrue(camper?.phoneNumber == "910-543-9000")
  }
    
}
