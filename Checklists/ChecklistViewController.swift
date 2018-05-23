//
//  ViewController.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 5/9/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
    }
    
    //array of ChecklistItems
    var items = [ChecklistItem]()
    
    //still hardcoded values in object init
    required init?(coder aDecoder: NSCoder) {
//        items = [ChecklistItem]()
        
        let row0item = ChecklistItem()
        row0item.text = "Walk the dog"
        row0item.checked = false
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "Brush my teeth"
        row1item.checked = false
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "Learn iOS development"
        row2item.checked = false
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Soccer practice"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "Eat ice cream"
        row4item.checked = false
        items.append(row4item)
        
        // generating additional lines of data to expand test checklist
        //BUG: This puts pointers to the same object in the array repeat times
        //     Creates an issue with the accessory toggling occurring on the same object in the array
        //     Need to figure out how to create UNIQUE instances in the array
        //     or a deep copy of objects to append to the array
//        let loopCount = Array(repeating: 0, count: 5)
//        for _ in loopCount {
//            items.append(contentsOf: [row0item, row1item, row2item, row3item, row4item])
//        }
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //returns how many rows to draw in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        //reference to each array item
        let item = items[indexPath.row]

        //sets label text when drawing row to cell
        configureText(for: cell, with: item)
        //function sets initial accessory state when drawing row to cell
        configureCheckmark(for: cell, with: item)
        
        return cell
    }

    //method handles behavior when row is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //remove from data model ('items' array)
        items.remove(at: indexPath.row)
        
        //remove from the table view
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        // tag is used here instead of an @IBOutlet since the element is reusable and has multiple instances
        let label = cell.viewWithTag(1000) as! UILabel
        
        //replace each item with text
        label.text = item.text
    }
    
    //sets initial state of togglable checkmark when row is drawn to cell -- fixes reused cell bug
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        if item.checked == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    // right nav button - Add item to table view
    @IBAction func addItem(){
        // count starts at 1, so full count would be "current index + 1"
        let newRowIndex = items.count
        
        let item = ChecklistItem()
        item.text = "New row, new row!"
        item.checked = false
        items.append(item)
        
        //sets IndexPath row to next available array index at section 0
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        //sticks the resulting IndexPath in an array -- Why???
        //Because the "InsertRow" method takes an array of IndexPaths as an argument?
        let indexPaths = [indexPath]
        //Finally, insert the new row
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
}
