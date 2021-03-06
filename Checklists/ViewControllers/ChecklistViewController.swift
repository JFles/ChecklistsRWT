//
//  ViewController.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 5/9/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    // currently selected checklist (using to set nav title)
    // will be nil until 'prepare(for:sender:)' executes for vc to receive obj -- so must be optional
    var checklist: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disables large title for the nav item since the parent controller has it enabled and the navItems
        // will inherit the parent's preference for title display
        navigationItem.largeTitleDisplayMode = .never
        
        // setting the nav controller title to the current checklist's name
        // is this safe? Found nil and crashed without proper segue -- will this never be nil when properly setup?
        title = checklist.name
        
        //may be a better place for sorting the checklists
        checklist.sortChecklistItems()
    }
    
    // utilizing prepare(for:sender:) for the delegate pattern
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            // edits the array item for the data source
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    //configures the cell for the tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        //reference to each array item
        let item = checklist.items[indexPath.row]

        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    //method handles behavior when row is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // swipe to delete delegate method
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //remove from data model ('items' array)
        checklist.items.remove(at: indexPath.row)
        
        //remove from the table view
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let checklistItemLabel = cell.viewWithTag(1000) as! UILabel
        let dueDateLabel = cell.viewWithTag(1002) as! UILabel
        
        if item.shouldRemind {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dueDateLabel.text = dateFormatter.string(from: item.dueDate)
            dueDateLabel.isHidden = false
            
            // set text color if the alarm has expired
            let currentDate = Date()
            if currentDate > item.dueDate {
                dueDateLabel.textColor = UIColor.red
            } else {
                dueDateLabel.textColor = UIColor.black
            }
        } else {
            dueDateLabel.isHidden = true
        }
        checklistItemLabel.text = item.text
    }
    
    //sets initial state of togglable checkmark when row is drawn to cell -- fixes reused cell bug
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        
        if item.checked == true {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
 
    // MARK: - Item Detail View Controller Delegate Methods
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        // get new final row index
        let newRowIndex = checklist.items.count
        // add to data source array
        checklist.items.append(item)
        
        // add new row to tableView
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        checklist.sortChecklistItems()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        // get index of itemToEdit in array of data source
        if let index = checklist.items.index(of: item) {
            // convert Int row into IndexPath
            let indexPath = IndexPath(row: index, section: 0)
            // consume indexpath to find correct cell to modify
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        
        checklist.sortChecklistItems()
        tableView.reloadData()
        
        navigationController?.popViewController(animated: true)
    }
}
