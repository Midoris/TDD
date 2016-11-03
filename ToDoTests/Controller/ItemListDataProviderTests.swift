//
//  ItemListDataProviderTests.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 17/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListDataProviderTests: XCTestCase {

    var sut: ItemListDataProvider!
    var tableView: UITableView!
    var controller: ItemListViewController!
    
    override func setUp() {
        super.setUp()
        sut = ItemListDataProvider()
        sut.itemManager = ItemManager()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyBoard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        _ = controller.view
        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }
    
    override func tearDown() {
        sut.itemManager?.removeAllItems()
        sut.itemManager = nil
        super.tearDown()
    }

    func testNumberOfSection_IsTwo() {
        let numberOfSections = tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 2)
    }

    func testNumberOfRowsInFirstSextion_ShouldBeIsToDoCount() {
        sut.itemManager?.add(item: ToDoItem(title: "First"))
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        sut.itemManager?.add(item: ToDoItem(title: "Second"))
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }

    func testNumberOfRowsInSeconSection_SouldBeDoneCount() {
        sut.itemManager?.add(item: ToDoItem(title: "First"))
        sut.itemManager?.add(item: ToDoItem(title: "Second"))
        sut.itemManager?.checkItem(at: 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        sut.itemManager?.checkItem(at: 0)
        tableView.reloadData()
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }

    func testCellRorRow_ReturnsItemCell() {
        sut.itemManager?.add(item: ToDoItem(title: "First"))
        tableView.reloadData()
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is ItemCell)
    }

    func testCellForRow_DequesCell() {
        let mockTableView = MockTableView.mockTableView(with: sut)
        sut.itemManager?.add(item: ToDoItem(title: "First"))
        mockTableView.reloadData()
        _ = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(mockTableView.cellGotDequed)
    }

    func testConfigCell_GetsCalledInCellForRow() {
        let mockTableView = MockTableView.mockTableView(with: sut)
        let toDoItem = ToDoItem(title: "First", itemDescription: "First description")
        sut.itemManager?.add(item: toDoItem)
        mockTableView.reloadData()
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockItemCell
        XCTAssertEqual(cell.toDoItem, toDoItem)
    }

    func testSellsInSectionTwo_GetsConfiguredWithDoneItems() {
        let mockTableView = MockTableView.mockTableView(with: sut)
        let firstItem = ToDoItem(title: "First", itemDescription: "First description")
        sut.itemManager?.add(item: firstItem)
        let secondItem = ToDoItem(title: "Second", itemDescription: "Second description")
        sut.itemManager?.add(item: secondItem)
        sut.itemManager?.checkItem(at: 1)
        mockTableView.reloadData()
        let cell = mockTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockItemCell
        XCTAssertEqual(cell.toDoItem, secondItem)
    }

    func testDeletionButtonInFirstSection_ShowsTitleCheck() {
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(deleteButtonTitle, "Check")
    }

    func testDeletionButtonInSecondSection_ShowsTitleUncheck() {
        let deleteButtonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))
        XCTAssertEqual(deleteButtonTitle, "Uncheck")
    }

    func testCheckingAnItem_ChecksItInItemManager() {
        sut.itemManager?.add(item: ToDoItem(title: "First"))
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(sut.itemManager?.toDoCount, 0)
        XCTAssertEqual(sut.itemManager?.doneCount, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
    }

    func testUncheckingAnItem_UnchecksItInItemManager() {
        sut.itemManager?.add(item: ToDoItem(title: "First"))
        sut.itemManager?.checkItem(at: 0)
        tableView.reloadData()
        tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 1))
        XCTAssertEqual(sut.itemManager?.toDoCount, 1)
        XCTAssertEqual(sut.itemManager?.doneCount, 0)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 0)
    }

    func testSelectionCell_SendsNotification() {
        let item = ToDoItem(title: "First")
        sut.itemManager?.add(item: item)
        expectation(forNotification: "ItemSelectedNotification", object: nil) { (notification) -> Bool in
            guard let index = notification.userInfo?["index"] as? Int else {
                return false
            }
            return index == 0
        }
        tableView.delegate?.tableView!(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        waitForExpectations(timeout: 3, handler: nil)
    }
    
}

extension ItemListDataProviderTests {
    class MockTableView: UITableView {

        var cellGotDequed = false

        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellGotDequed = true
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }

        class func mockTableView(with dataSource: UITableViewDataSource) -> MockTableView {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), style: .plain)
            mockTableView.dataSource = dataSource
            mockTableView.register(MockItemCell.self, forCellReuseIdentifier: "ItemCell")
            return mockTableView
        }
    }

    class MockItemCell: ItemCell {

        var toDoItem: ToDoItem?

        override func configCell(with item: ToDoItem, checked: Bool = false) {
            toDoItem = item
        }
    }
}

