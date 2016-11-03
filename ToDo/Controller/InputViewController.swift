//
//  InputViewController.swift
//  ToDo
//
//  Created by Ievgenii Iablonskyi on 22/10/2016.
//  Copyright © 2016 Ievgenii Iablonskyi. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()

    @IBAction func save() {
        guard let titleString  = titleTextField.text , titleString.characters.count > 0 else { return }
        let date: Date?
        if let dateText = dateTextField.text , dateText.characters.count > 0 {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil
        }
        var descriptionString: String?
        if (descriptionTextField.text?.characters.count)! > 0 {
            descriptionString = descriptionTextField.text
        }

        if let locationName = locationTextField.text , locationName.characters.count > 0 {
            if let address = descriptionTextField.text , address.characters.count > 0 {
                geocoder.geocodeAddressString(address) {
                    [unowned self] (placeMarks, error) -> Void in
                    let placeMark = placeMarks?.first
                    let item = ToDoItem(title: titleString, itemDescription: descriptionString, timestamp: date?.timeIntervalSince1970, location: Location(name: locationName, coordinate: placeMark?.location?.coordinate))
                    DispatchQueue.main.async {
                        self.itemManager?.add(item: item)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        } else {
            let item = ToDoItem(title: titleString, itemDescription: descriptionString, timestamp: date?.timeIntervalSince1970)
            self.itemManager?.add(item: item)
            dismiss(animated: true, completion: nil)
        }
    }

}
