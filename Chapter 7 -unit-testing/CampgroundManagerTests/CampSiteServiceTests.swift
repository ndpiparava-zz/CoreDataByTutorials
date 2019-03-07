//
//  CampSiteServiceTests.swift
//  CampgroundManagerTests
//
//  Created by npiparav on 07/03/19.
//  Copyright © 2019 Razeware. All rights reserved.
//

import UIKit
import XCTest
import CampgroundManager
import CoreData

class CampSiteServiceTests: XCTestCase {
  
  
  //MARK: Properties
  var campSiteService: CampSiteService!
  var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
      
      coreDataStack = TestCoreDataStack()
      campSiteService = CampSiteService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
      
      campSiteService = nil
      coreDataStack = nil
    }
    
  func testAddCampSite() {
    
    let campSite = campSiteService.addCampSite(1, electricity: true, water: true)
    
    XCTAssertTrue(campSite.siteNumber == 1, "Site number should be 1")
    XCTAssertTrue(campSite.electricity!.boolValue, "Site should have electricity")
    XCTAssertTrue(campSite.water!.boolValue, "Site Sould have water")
  }
  
  func testRootContextIsSavedAfterAddingCampsiter() {
    
    let derivedContext = coreDataStack.newDerivedContext()
    
    campSiteService = CampSiteService(managedObjectContext: derivedContext, coreDataStack: coreDataStack)
    
    expectation(forNotification: NSNotification.Name.NSManagedObjectContextDidSave.rawValue, object: coreDataStack.mainContext) { (notification) -> Bool in
      return true
    }
    
    let campSite = campSiteService.addCampSite(1, electricity: true, water: true)
    
    waitForExpectations(timeout: 2.0) { (error) in
       XCTAssertNil(error, "Save did not occur")
    }
   
  }
  
  func testGetCampSiteWithMatchingSiteNumber() {
    
    _ = campSiteService.addCampSite(1, electricity: true, water: true)
    
    let campSite = campSiteService.getCampSite(1)
    XCTAssertNotNil(campSite, "A campsite should be returned")
    
  }
  
  func testGetCamoSiteNoMatchingSiteNumber() {
    _ = campSiteService.addCampSite(1, electricity: true, water: true)
    
    let campSite = campSiteService.getCampSite(2)
    XCTAssertNil(campSite, "No campsite should be returend")
  }
    
}
