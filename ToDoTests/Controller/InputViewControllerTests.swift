//
//  InputViewControllerTests.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 22/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import XCTest
@testable import ToDo
import CoreLocation

class InputViewControllerTests: XCTestCase {

    var sut: InputViewController!
    var placeMark: MockPlaceMark!
    
    override func setUp() {
        super.setUp()

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyBoard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        _ = sut.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_HasTitleTextField() {
        XCTAssertNotNil(sut.titleTextField)
    }

    func test_HasLocationTextFIeld() {
        XCTAssertNotNil(sut.locationTextField)
    }

    func test_HasAddressTextField() {
        XCTAssertNotNil(sut.addressTextField)
    }

    func test_HasDescroptionTextFIeld() {
        XCTAssertNotNil(sut.descriptionTextField)
    }

    func test_HasSaveButton() {
        XCTAssertNotNil(sut.saveButton)
    }

    func test_HasCancelButton() {
        XCTAssertNotNil(sut.cancelButton)
    }

    func testSave_UsesGeocoderToGetCoordinateFromAdress() {
        let mockInputViewController = MockInputViewController()
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()

        mockInputViewController.titleTextField.text = "Test title"
        mockInputViewController.dateTextField.text = "02/22/2016"
        mockInputViewController.locationTextField.text = "Office"
        mockInputViewController.addressTextField.text = "Infinite loop 1, Cupertino"
        mockInputViewController.descriptionTextField.text = "Test Description"

        let mockGeocoder = MockGeocoder()
        mockInputViewController.geocoder = mockGeocoder
        mockInputViewController.itemManager = ItemManager()
        let expectationSave = expectation(description: "Saveing")

        mockInputViewController.completionHandler = {
            expectationSave.fulfill()
        }
        mockInputViewController.save()
        placeMark = MockPlaceMark()
        let coordinate = CLLocationCoordinate2D(latitude: 37.3316851, longitude: -122.0300674)
        placeMark.mokCoordinate = coordinate
        mockGeocoder.completionHandler?([placeMark], nil)
        waitForExpectations(timeout: 1, handler: nil)
        let item = mockInputViewController.itemManager?.item(at: 0)
        let testItem = ToDoItem(title: "Test title", itemDescription: "Test Description", timestamp: 1456074000, location: Location(name: "Office", coordinate: coordinate))
        XCTAssertEqual(item, testItem)
    }

    func testSave_UserPutsOnlyTitle() {
        sut.titleTextField.text = "Test title"
        sut.itemManager = ItemManager()
        sut.save()
        let item = sut.itemManager?.item(at: 0)
        let testItem = ToDoItem(title: "Test title")
        XCTAssertEqual(item, testItem)
    }

    func testSave_UserPutsTitleDescriptionAndDate() {
        sut.titleTextField.text = "Test title"
        sut.descriptionTextField.text = "Test Description"
        sut.dateTextField.text = "02/22/2016"
        sut.itemManager = ItemManager()
        sut.save()
        let item = sut.itemManager?.item(at: 0)
        let testItem = ToDoItem(title: "Test title", itemDescription: "Test Description", timestamp: 1456074000)
        XCTAssertEqual(item, testItem)
    }

    func testSave_UserPutsNothingAndPressSave_NothingShouldBeSaved() {
        sut.itemManager = ItemManager()
        let toDoCountBeforeSaving = sut.itemManager?.toDoCount
        sut.save()
        XCTAssertEqual(sut.itemManager?.toDoCount, toDoCountBeforeSaving)
    }

    func testSaveButton_HasAnAction() {
        let saveButton: UIButton = sut.saveButton
        guard let actions = saveButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }
        XCTAssertTrue(actions.contains("save"))
    }

    func test_GeocoderWorksAsExpected() {
        let expect = expectation(description: "Wait for a geocode")
        CLGeocoder().geocodeAddressString("Infinite loop 1, Cupertino") {
            (placeMarks, error) -> Void in
            let placeMark = placeMarks?.first
            let coordinate = placeMark?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }
            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }
            XCTAssertEqualWithAccuracy(latitude, 37.3316941, accuracy: 0.000001)
            XCTAssertEqualWithAccuracy(longitude, -122.030127, accuracy: 0.000001)
            expect.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testSave_DismissesViewController() {
        let mockInputViewController = MockInputViewController()
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Trst title"
        mockInputViewController.save()
        XCTAssertTrue(mockInputViewController.dismissGotCalled)

    }

}

extension InputViewControllerTests {

    class MockGeocoder: CLGeocoder {

        var completionHandler: CLGeocodeCompletionHandler?

        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }

    class MockPlaceMark: CLPlacemark {

        var mokCoordinate: CLLocationCoordinate2D?

        override var location: CLLocation? {
            guard let coordinate = mokCoordinate else {
                return CLLocation()
            }
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }

    class MockInputViewController: InputViewController {

        var dismissGotCalled = false
        var completionHandler: (() -> Void)?

        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            dismissGotCalled = true
            completionHandler?()
        }
    }
}
