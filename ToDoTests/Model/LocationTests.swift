//
//  LocationTests.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 16/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import XCTest
@testable import ToDo
import CoreLocation

class LocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInit_ShouldSetLocationNameAndCoordinate() {
        let testCoordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        let location = Location(name: "Test name", coordinate: testCoordinate)

        XCTAssertEqual(location.coordinate?.latitude, testCoordinate.latitude, "Initializer should set latitude")
        XCTAssertEqual(location.coordinate?.longitude, testCoordinate.longitude, "Initializer should set longitude")
    }

    func testInit_ShouldSetName() {
        let location = Location(name: "Test name")
        XCTAssertEqual(location.name, "Test name", "Initializer should set name")
    }

    func testEqualLocations_shouldBeEqual() {
        let firstLocation = Location(name: "Home")
        let secondLocation = Location(name: "Home")
        XCTAssertEqual(firstLocation, secondLocation)
    }

    func testWhenLatitudeDiffers_ShouldNotBeEqual() {
        perfomNotEqualTestWithLocationProperties(firstName: "Home", SecondName: "Home", firstLongLat: (1.0, 0.0), secondLongLat: (0.0, 0.0))
    }

    func testWhenLongitudeDiffers_ShouldNotBeEqual() {
        perfomNotEqualTestWithLocationProperties(firstName: "Home", SecondName: "Home", firstLongLat: (0.0, 1.0), secondLongLat: (0.0, 0.0))
    }

    func testWhenOneHasCoordinateAndTheOtherDoesnt_ShouldNotBeEqual() {
        perfomNotEqualTestWithLocationProperties(firstName: "Home", SecondName: "Home", firstLongLat: (0.0, 0.0), secondLongLat: nil)
    }

    func testWhenNamesDiffers_ShouldNotBeEqual() {
        perfomNotEqualTestWithLocationProperties(firstName: "Office", SecondName: "Home", firstLongLat: nil, secondLongLat: nil)
    }

    func test_CanBeSerializedAndDeserialized() {
        let location = Location(name: "Home", coordinate: CLLocationCoordinate2DMake(50.0, 6.0))
        let dict = location.plistDict
        XCTAssertNotNil(dict)
        let recreatedLOcation = Location(dict: dict)
        XCTAssertEqual(location, recreatedLOcation)
    }

    func perfomNotEqualTestWithLocationProperties(firstName: String, SecondName: String, firstLongLat: (Double, Double)?, secondLongLat: (Double, Double)?) {
        let firstCoord: CLLocationCoordinate2D?
        if let firstLongLat = firstLongLat {
            firstCoord = CLLocationCoordinate2D(latitude: firstLongLat.0, longitude: firstLongLat.1)
        } else {
            firstCoord = nil
        }
        let firstLocation = Location(name: firstName, coordinate: firstCoord)
        let secondCoord: CLLocationCoordinate2D?
        if let secondLongLat = secondLongLat {
            secondCoord = CLLocationCoordinate2D(latitude: secondLongLat.0, longitude: secondLongLat.1)
        } else {
            secondCoord = nil
        }
        let secondLocation = Location(name: SecondName, coordinate: secondCoord)
        XCTAssertNotEqual(firstLocation, secondLocation)
    }

}
