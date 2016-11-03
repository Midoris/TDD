//
//  ToDoItemTests.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 16/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import XCTest
@testable import ToDo

class ToDoItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

        super.tearDown()
    }

    func testInit_ShouldSetTitle() {
        let item = ToDoItem(title: "Test title")
        XCTAssertEqual(item.title, "Test title", "Initializer should set the item title")
    }

    func testInit_ShouldSetTitleAndDescription() {
        let item = ToDoItem(title: "Test title", itemDescription: "Test description")
        XCTAssertEqual(item.itemDescription, "Test description", "Initializer should set the item description")
    }

    func testInit_ShouldSetTitleAndDescriptionAndTimestamp() {
        let item = ToDoItem(title: "Test title", itemDescription: "Test description", timestamp: 0.0)
        XCTAssertEqual(item.timestamp, 0.0, "Initializer should set the timestamp")
    }

    func testInit_ShouldSetTitleAndDescriptionAndTimestampAndLocation() {
        let location = Location(name: "Test name")
        let item = ToDoItem(title: "Test title", itemDescription: "Test description", timestamp: 0.0, location: location)
        XCTAssertEqual(location.name, item.location?.name, "Initializer should set the location")
    }

    func testEqualItems_ShouldBeEqual() {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "First")
        XCTAssertEqual(firstItem, secondItem)
    }

    func testWhenLocationDiffers_ShouldBeNotEqual() {
        let firstItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 0.0, location: Location(name: "Home"))
        let secontItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 0.0, location: Location(name: "Office"))
        XCTAssertNotEqual(firstItem, secontItem)
    }

    func testWhenOneOneLocationIsNilANdOtherIsnt_ShouldNotBeEqual() {
        var firstItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 0.0, location: nil)
        var secontItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 0.0, location: Location(name: "Office"))
        XCTAssertNotEqual(firstItem, secontItem)
        firstItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 0.0, location: Location(name: "Office"))
        secontItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 0.0, location: nil)
        XCTAssertNotEqual(firstItem, secontItem)
    }

    func testWhenTimestampDiffers_ShouldBeNotEqual() {
        let firstItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 0.0)
        let secontItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 1.0)
        XCTAssertNotEqual(firstItem, secontItem)
    }

    func testWhenDescriptionDiffers_ShouldBeNotEqual() {
        let firstItem = ToDoItem(title: "First title", itemDescription: "First description")
        let secontItem = ToDoItem(title: "First title", itemDescription: "Second description")
        XCTAssertNotEqual(firstItem, secontItem)
    }

    func testWhenTitleDiffers_ShouldBeNotEqual() {
        let firstItem = ToDoItem(title: "First title")
        let secontItem = ToDoItem(title: "Second title")
        XCTAssertNotEqual(firstItem, secontItem)
    }

    func test_HasPlistDictionaryProperty() {
        let item = ToDoItem(title: "First")
        let dictionary = item.plistDict
        XCTAssertNotNil(dictionary)
        XCTAssertTrue(dictionary is NSDictionary)
    }

    func test_canBeCreatedFromPlistDictionary() {
        let location = Location(name: "Home")
        let item = ToDoItem(title: "The title", itemDescription: "The description", timestamp: 1.0, location: location)
        let dict  = item.plistDict
        let recreatedItem = ToDoItem(dict: dict)
        XCTAssertEqual(item, recreatedItem)
    }


}
