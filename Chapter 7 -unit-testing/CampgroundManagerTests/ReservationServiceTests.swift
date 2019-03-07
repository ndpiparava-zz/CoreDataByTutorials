//
//  ReservationServiceTests.swift
//  CampgroundManagerTests
//
//  Created by npiparav on 07/03/19.
//  Copyright © 2019 Razeware. All rights reserved.
//

import XCTest
import Foundation
import CoreData
import CampgroundManager

class ReservationServiceTests: XCTestCase {
  
  //MARK: Properties
  var campSiteService: CampSiteService!
  var camperService: CamperService!
  
  var reservationService: ReservationService!
  var coreDataStack: CoreDataStack!
  
    override func setUp() {
        super.setUp()
      
      coreDataStack = TestCoreDataStack()
      camperService = CamperService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
      campSiteService = CampSiteService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
      reservationService = ReservationService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
      camperService = nil
      campSiteService = nil
      reservationService = nil
      coreDataStack = nil
    }
    
  
  func testReserveCampSitePostivenumberOfDays () {
    let camper = camperService.addCamper("Johny Appleseed", phoneNumber: "408-555-12344")
    let campSite = campSiteService.addCampSite(15, electricity: false, water: false)
    
    let result = reservationService.reserveCampSite(campSite, camper: camper!, date: Date(), numberOfNights: 5)
    
    XCTAssertNotNil(result.reservation, "Reservation should not be nil")
    XCTAssertNil(result.error, "No Error should be present")
    XCTAssertTrue(result.reservation?.status == "Reserved", "Status should be Reserved")
    
    
  }
  
  func testReserveCampSiteNegativeNumverOfDays () {
    
    let camper = camperService.addCamper("Johnny Applessed", phoneNumber: "408-55-1234")
    let campSite = campSiteService.addCampSite(15, electricity: false, water: false)
    
    let result = reservationService!.reserveCampSite(campSite, camper: camper!, date: Date(), numberOfNights: -1)
    
    XCTAssertNotNil(result.reservation, "Reservation should not be nil")
    XCTAssertNotNil(result.error, "An error should be present")
    XCTAssertTrue(result.error?.userInfo["Problem"] as? String == "Invalid number of days", "Error problem should be present")
    XCTAssertTrue(result.reservation?.status == "Invalid", "Status should be Invalid")
    
  }
    
}
