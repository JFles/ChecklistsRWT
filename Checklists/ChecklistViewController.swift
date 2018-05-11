//
//  ViewController.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 5/9/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    //first iteration -- clunky and needs changing.
    //Hard coded strings for checklist titles
    let row0text = "What the Barty Crouch"
    let row1text = "Why lie, son"
    let row2text = "I need more coffee"
    let row3text = "And then it was Eirday"
    let row4text = "Better than auto layout..."
    var row0checked = false
    var row1checked = false
    var row2checked = false
    var row3checked = false
    var row4checked = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //returns how many rows to draw in table
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        // tag is used here instead of an @IBOutlet since the element is reusable and has multiple instances
        let label = cell.viewWithTag(1000) as! UILabel
        
        // modulo used to fill all rows easily
        if indexPath.row % 5 == 0 {
            label.text = row0text
        } else if indexPath.row % 5 == 1 {
            label.text = row1text
        } else if indexPath.row % 5 == 2 {
            label.text = row2text
        } else if indexPath.row % 5 == 3 {
            label.text = row3text
        } else if indexPath.row % 5 == 4 {
            label.text = row4text
        }

        //function sets initial accessory state when drawing row to cell
        configureCheckmark(for: cell, at: indexPath)
        
        return cell
    }

    //method handles behavior when row is tapped
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            var isChecked = false
            if indexPath.row == 0 {
                row0checked = !row0checked
                isChecked = row0checked
            } else if indexPath.row == 1 {
                row1checked = !row1checked
                isChecked = row1checked
            } else if indexPath.row == 2 {
                row2checked = !row2checked
                isChecked = row2checked
            } else if indexPath.row == 3 {
                row3checked = !row3checked
                isChecked = row3checked
            } else if indexPath.row == 4 {
                row4checked = !row4checked
                isChecked = row4checked
            }
            if isChecked {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //sets initial state of togglable checkmark when row is drawn to cell -- fixes reused cell bug
    func configureCheckmark(for cell: UITableViewCell,
                            at indexPath: IndexPath) {
        var isChecked = false
        
        if indexPath.row == 0 {
            isChecked = row0checked
        } else if indexPath.row == 1 {
            isChecked = row1checked
        } else if indexPath.row == 2 {
            isChecked = row2checked
        } else if indexPath.row == 3 {
            isChecked = row3checked
        } else if indexPath.row == 4 {
            isChecked = row4checked
        }
        
        if isChecked == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}
