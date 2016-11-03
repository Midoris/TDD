//
//  DetailViewControllerTests.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 21/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import XCTest
@testable import ToDo
import CoreLocation

class DetailViewControllerTests: XCTestCase {

    var sut: DetailViewController!
    
    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        _ = sut.view
    }
    
    override func tearDown() {
        sut.itemInfo?.0.removeAllItems()
        super.tearDown()
    }

    func test_HasTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
    }

    func test_HasDateLabel() {
        XCTAssertNotNil(sut.dateLabel)
    }

    func test_HasLocationNameLabel() {
        XCTAssertNotNil(sut.locationNameLabel)
    }

    func test_HasDescriptionLabel() {
        XCTAssertNotNil(sut.descriptionLabel)
    }

    func test_HasMapView() {
        XCTAssertNotNil(sut.mapView)
    }

    func testSettingItemInfo_SetsTexstsToLabels() {
        let coordinate = CLLocationCoordinate2D(latitude: 51.2277, longitude: 6.7735)
        let itemManager = ItemManager()
        itemManager.add(item: ToDoItem(title: "The Title", itemDescription: "The Description", timestamp: 1456150025, location: Location(name: "Home", coordinate: coordinate)))
        sut.itemInfo = (itemManager, 0)
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        XCTAssertEqual(sut.titleLabel.text, "The Title")
        XCTAssertEqual(sut.dateLabel.text, "02/22/2016")
        XCTAssertEqual(sut.locationNameLabel.text, "Home")
        XCTAssertEqual(sut.descriptionLabel.text, "The Description")
        XCTAssertEqualWithAccuracy(sut.mapView.centerCoordinate.latitude, coordinate.latitude, accuracy: 0.001)
    }

    func testCheckItem_ChecksItemInItemManager() {
        let itemManager = ItemManager()
        itemManager.add(item: ToDoItem(title: "The title"))
        sut.itemInfo = (itemManager, 0)
        sut.checkItem()
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
    }

}
