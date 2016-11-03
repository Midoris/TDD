//
//  DetailViewController.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 21/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var itemInfo: (ItemManager, Int)?
    let dateFormatter: DateFormatter = {
        let dateFormetter = DateFormatter()
        dateFormetter.dateFormat = "MM/dd/yyyy"
        return dateFormetter
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let itemInfo = itemInfo
            else { fatalError() }
        let item = itemInfo.0.item(at: itemInfo.1)
        titleLabel.text = item.title
        locationNameLabel.text = item.location?.name
        descriptionLabel.text = item.itemDescription
        if let timestamp = item.timestamp {
            let date  = Date(timeIntervalSince1970: timestamp)
            dateLabel.text = dateFormatter.string(from: date)
        }
        if let coordinate = item.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
            mapView.region = region
        }
    }

    func checkItem() {
        if let itemInfo = itemInfo {
            itemInfo.0.checkItem(at: itemInfo.1)
        }
    }

}
