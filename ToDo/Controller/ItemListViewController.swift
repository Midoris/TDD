//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 17/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: UITableViewDataSource & UITableViewDelegate & ItemManagerettable!
    let itemManager = ItemManager()

    override func viewDidLoad() {
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = self.itemManager
        let notificationName = Notification.Name("ItemSelectedNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(ItemListViewController.showDetails(sender:)), name: notificationName, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
            nextViewController.itemManager = self.itemManager
            present(nextViewController, animated: true, completion: nil)
        }
    }

    func showDetails(sender: Notification) {
        guard let index = sender.userInfo?["index"] as? Int else {
            fatalError()
        }
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            nextViewController.itemInfo = (itemManager, index)
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }

}
