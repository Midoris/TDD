//
//  ItemListDataProvider.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 17/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import UIKit

class ItemListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate, ItemManagerettable {

    var itemManager: ItemManager?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let itemManager = itemManager else { return 0 }
        guard let itemSection = Section(rawValue: section) else {
            fatalError()
        }
        let numberOfRows: Int
        switch itemSection {
        case .toDo:
            numberOfRows = itemManager.toDoCount
        case .done:
            numberOfRows = itemManager.doneCount
        }
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        guard let itemManager = itemManager else { fatalError() }
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        let item: ToDoItem
        switch section {
        case .toDo:
            item = itemManager.item(at: indexPath.row)
        case .done:
            item = itemManager.doneItem(at: indexPath.row)
        }
        cell.configCell(with: item)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        let buttonTitle: String
        switch section {
        case .toDo:
            buttonTitle = "Check"
        case .done :
            buttonTitle = "Uncheck"
        }
        return buttonTitle
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let itemManager = itemManager else { fatalError() }
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        switch section {
        case .toDo :
            itemManager.checkItem(at: indexPath.row)
        case .done :
            itemManager.uncheckItem(at: indexPath.row)
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itmeSection = Section(rawValue: indexPath.section) else {
            fatalError()
        }
        switch itmeSection {
        case .toDo:
            let notificationName = Notification.Name("ItemSelectedNotification")
            NotificationCenter.default.post(name: notificationName, object: self, userInfo: ["index" : indexPath.row])
        default:
            break
        }
    }
}

enum Section: Int {
    case toDo
    case done
}

@objc protocol ItemManagerettable {
    var itemManager: ItemManager? { get set }
}
