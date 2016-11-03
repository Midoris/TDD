//
//  ItemManagerTests.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 16/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemManagerTests: XCTestCase {

    var sut: ItemManager!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ItemManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut.removeAllItems()
        sut = nil
        super.tearDown()
    }

    func testToDoCount_Initially_ShouldBeZero() {
        XCTAssertEqual(sut.toDoCount, 0, "Initially toDoCount should be zero")
    }

    func testDoneCount_Initially_ShouldBeZero() {
        XCTAssertEqual(sut.doneCount, 0, "Initially doneCount should be zero")
    }

    func testToDoCont_AfterAddingOneItem_IsOne() {
        sut.add(item: ToDoItem(title: "Test item"))
        XCTAssertEqual(sut.toDoCount, 1, "toDo count should be 1")
    }

    func testItemAtIndex_ShouldReturnPreviouslyAddedItem() {
        let item = ToDoItem(title: "Item")
        sut.add(item: item)
        let returnedItem = sut.item(at: 0)
        XCTAssertEqual(item, returnedItem, "Should be the same item")
    }

    func testCheckingItem_ChangesCountOfToDoAndDoneItems() {
        sut.add(item: ToDoItem(title: "First item"))
        sut.checkItem(at: 0)
        XCTAssertEqual(sut.toDoCount, 0, "toDoCount should be zero")
        XCTAssertEqual(sut.doneCount, 1, "doneCount should be 1")
    }

    func testCheckingItem_RemovesItFromTheToDoItemList() {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "Second")
        sut.add(item: firstItem)
        sut.add(item: secondItem)
        sut.checkItem(at: 0)
        XCTAssertEqual(sut.item(at: 0).title, secondItem.title)
    }

    func testDoneItemAtIndex_ShouldReturnPreviouslyCheckedItem() {
        let item = ToDoItem(title: "Item")
        sut.add(item: item)
        sut.checkItem(at: 0)
        let returnedItem = sut.doneItem(at: 0)
        XCTAssertEqual(item, returnedItem)
    }

    func testRemoveAllIrems_ShouldResultInCountsBeZero(){
        sut.add(item: ToDoItem(title: "First"))
        sut.add(item: ToDoItem(title: "Second"))
        sut.checkItem(at: 0)
        XCTAssertEqual(sut.toDoCount, 1, "toDoCount should be 1")
        XCTAssertEqual(sut.doneCount, 1, "doneCount should be 1")
        sut.removeAllItems()
        XCTAssertEqual(sut.toDoCount, 0, "toDoCount should be 0")
        XCTAssertEqual(sut.doneCount, 0, "doneCount should be 0")
    }

    func testAddingTheSameItem_ShouldNotIncreaseCount() {
        sut.add(item: ToDoItem(title: "First"))
        sut.add(item: ToDoItem(title: "First"))
        XCTAssertEqual(sut.toDoCount, 1, "toDoCount should be 1")
    }

    func test_ToDoItemsGetSerialized() {
        var itemManager: ItemManager? = ItemManager()
        let firstItem = ToDoItem(title: "First")
        itemManager?.add(item: firstItem)
        let secondItem = ToDoItem(title: "Second")
        itemManager?.add(item: secondItem)
        NotificationCenter.default.post(name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        itemManager = nil
        XCTAssertNil(itemManager)
        itemManager = ItemManager()
        XCTAssertEqual(itemManager?.toDoCount, 2)
        XCTAssertEqual(itemManager?.item(at: 0), firstItem)
        XCTAssertEqual(itemManager?.item(at: 1), secondItem)
    }

    func test_DoneItemsGetSerialized() {
        var itemManager: ItemManager? = ItemManager()
        let firstItem = ToDoItem(title: "First")
        itemManager?.add(item: firstItem)
        itemManager?.checkItem(at: 0)
        let secondItem = ToDoItem(title: "Second")
        itemManager?.add(item: secondItem)
        itemManager?.checkItem(at: 0)
        XCTAssertEqual(itemManager?.doneCount, 2)
        NotificationCenter.default.post(name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        itemManager = nil
        XCTAssertNil(itemManager)
        itemManager = ItemManager()
        XCTAssertEqual(itemManager?.doneCount, 2)
        XCTAssertEqual(itemManager?.doneItem(at: 0), firstItem)
        XCTAssertEqual(itemManager?.doneItem(at: 1), secondItem)
    }




}
