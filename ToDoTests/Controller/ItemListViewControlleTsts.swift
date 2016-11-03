//
//  ItemListViewControlleTsts.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 17/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListViewControlleTsts: XCTestCase {

    var sut: ItemListViewController!
    
    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyBoard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        _ = sut.view
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_TableViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(sut.tableView)
    }

    func testViewDidLoad_ShouldSetTableViewDataSource() {
        XCTAssertNotNil(sut.tableView.dataSource)
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }

    func testViewDidLoad_ShouldSetTableViewDelegate() {
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }

    func testViewDidLoad_ShouldSetDelegateAndDataSourceToSameObject() {
        XCTAssertEqual(sut.tableView.delegate as? ItemListDataProvider, sut.tableView.dataSource as? ItemListDataProvider)
    }

    func testItemListViewController_HasAddBurButtonWithSelfAsTarger() {
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem?.target as? UIViewController, sut)
    }

    func testAddItem_PresentsAddItemViewController() {
        let inputViewComtroller = presentedInputViewController()
        XCTAssertNotNil(inputViewComtroller?.titleTextField)
    }

    func testItemListVC_SharesItemManagerWithInputVC() {
        let inputViewComtroller = presentedInputViewController()
        guard let inputItemManager = inputViewComtroller?.itemManager else {
            fatalError()
            return
        }
        XCTAssertTrue(sut.itemManager === inputViewComtroller?.itemManager)
    }


    func testViewDidLoad_SetsItemManagerToDataProvider() {
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }

    func testViewWillAppear_ReloadDaataGetsCalled() {
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        XCTAssertTrue(mockTableView.reloadDataGotCalled)

    }

    func testItemSelectedNotification_PushesDetalVC() {
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        _ = sut.view
        let notificationName = Notification.Name("ItemSelectedNotification")
        NotificationCenter.default.post(name: notificationName, object: self, userInfo: ["index" : 1])
        guard let detalViewController = mockNavigationController.pushedVIewController as? DetailViewController else {
            XCTFail()
            return
        }
        guard let detalItemManager = detalViewController.itemInfo?.0 else {
            XCTFail()
            return
        }
        guard let index = detalViewController.itemInfo?.1 else {
            XCTFail()
            return
        }
        _ = detalViewController.view
        XCTAssertNotNil(detalViewController.titleLabel)
        XCTAssertTrue(detalItemManager === sut.itemManager)
        XCTAssertEqual(index, 1)
    }

    func presentedInputViewController() -> InputViewController? {
        XCTAssertNil(sut.presentedViewController)
        guard let addButton = sut.navigationItem.rightBarButtonItem else {
            fatalError()
            return nil
        }
        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.perform(addButton.action, with: addButton)
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
        return sut.presentedViewController as! InputViewController
    }

}

extension ItemListViewControlleTsts {

    class MockTableView: UITableView {

        var reloadDataGotCalled = false

        override func reloadData() {
            reloadDataGotCalled = true
        }
    }

    class MockNavigationController: UINavigationController {

        var pushedVIewController: UIViewController?

        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedVIewController = viewController
            super.pushViewController(viewController, animated: animated)

        }
    }
}
