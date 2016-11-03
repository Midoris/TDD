//
//  ItemCellTests.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 20/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemCellTests: XCTestCase {

    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testSUT_HasNameLabel() {
        let cell = dequeuedItemCell(for: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell.titleLabel)
    }

    func testSUT_HasLocationLabel() {
        let cell = dequeuedItemCell(for: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell.locationLabel)
    }

    func testSUT_HasDetalLabel() {
        let cell = dequeuedItemCell(for: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell.dateLabel)
    }

    func testConfigWithItem_SetsLabelsTexts() {
        let cell = dequeuedItemCell(for: IndexPath(row: 0, section: 0))
        cell.configCell(with: ToDoItem(title: "First", itemDescription: nil, timestamp: 1456150025, location: Location(name: "Home")))
        XCTAssertEqual(cell.titleLabel.text, "First")
        XCTAssertEqual(cell.locationLabel.text, "Home")
        XCTAssertEqual(cell.dateLabel.text, "02/22/2016")
    }

    func testTitle_ForCheckedTasks_IsStrokeThrough() {
        let cell = dequeuedItemCell(for: IndexPath(row: 0, section: 0))
        let toDoItem = ToDoItem(title: "First", itemDescription: nil, timestamp: 1456150025, location: Location(name: "Home"))
        cell.configCell(with: toDoItem, checked: true)
        let attributedString = NSAttributedString(string: "First", attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
        XCTAssertNil(cell.locationLabel.text)
        XCTAssertNil(cell.dateLabel.text)
    }

    func dequeuedItemCell(for indexPath: IndexPath) -> ItemCell {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        _ = controller.view
        let tableView = controller.tableView
        let dataProvider = FakeDataSource()
        tableView?.dataSource = dataProvider
        let cell = tableView?.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        return cell
    }


 }

extension ItemCellTests {

    class FakeDataSource: NSObject, UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }

    }
}
