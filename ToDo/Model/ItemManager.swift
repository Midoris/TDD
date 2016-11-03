//
//  ItemManager.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 16/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import UIKit

class ItemManager: NSObject {
    var toDoCount: Int { return toDoItems.count }
    var doneCount: Int { return doneItems.count }
    private var toDoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()
    var toDoPathURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else {
            print("Something wemt wrong. Documents url could not be found")
            fatalError()
        }
        return documentURL.appendingPathComponent("toDoItems.plist")
    }
    var donePathURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else {
            print("Something wemt wrong. Documents url could not be found")
            fatalError()
        }
        return documentURL.appendingPathComponent("doneItems.plist")
    }


    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(ItemManager.save), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        // ToDo Items
        if let nsToDoItems = NSArray(contentsOf: toDoPathURL) {
            for dict in nsToDoItems {
                if let toDoItem = ToDoItem(dict: dict as! NSDictionary) {
                    toDoItems.append(toDoItem)
                }
            }
        }
        // Done Items
        if let nsDoneItems = NSArray(contentsOf: donePathURL) {
            for dict in nsDoneItems {
                if let doneItem = ToDoItem(dict: dict as! NSDictionary) {
                    doneItems.append(doneItem)
                }
            }
        }

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }

    func add(item: ToDoItem) {
        if !toDoItems.contains(item) {
            toDoItems.append(item)
        }
    }

    func item(at index: Int) -> ToDoItem {
        return toDoItems[index]
    }

    func checkItem(at index: Int) {
        let item = toDoItems.remove(at: index)
        doneItems.append(item)
    }

    func uncheckItem(at index: Int) {
        let item = doneItems.remove(at: index)
        toDoItems.append(item)
    }

    func doneItem(at index: Int) -> ToDoItem {
        return doneItems[index]
    }

    func removeAllItems() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }

    func save() {
        saveItems(itemsTosave: toDoItems, itemsPathURL: toDoPathURL)
        saveItems(itemsTosave: doneItems, itemsPathURL: donePathURL)
    }

    private func saveItems(itemsTosave: [ToDoItem], itemsPathURL: URL) {
        var nsItems = [AnyObject]()
        for item in itemsTosave {
            nsItems.append(item.plistDict)
        }
        if nsItems.count > 0 {
            (nsItems as NSArray).write(to: itemsPathURL, atomically: true)
        } else {
            do {
                try FileManager.default.removeItem(at: itemsPathURL)
            } catch {
                print(error)
            }
        }
    }

}
