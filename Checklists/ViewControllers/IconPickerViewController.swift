//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 6/10/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import Foundation
import UIKit

protocol IconPickerViewControllerDelegate: class {
    func IconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    weak var delegate: IconPickerViewControllerDelegate?
    
    // possible icons by filename
    // is the data model for this view
    let icons = ["Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries", "Inbox", "No Icon", "Photos", "Trips"]
    
    // MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        
        let iconName = icons[indexPath.row]
//        cell.imageView!.image = UIImage(named: iconName)
//        cell.textLabel!.text = iconName
        cell.imageView?.image = UIImage(named: iconName)
        cell.textLabel?.text = iconName

        return cell
    }
}
