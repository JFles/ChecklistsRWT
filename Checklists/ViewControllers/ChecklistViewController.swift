//
//  ViewController.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 5/9/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    //array of ChecklistItems
    var items = [ChecklistItem]()
    
    // currently selected checklist (using to set nav title)
    var checklist: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disables large title for the nav item since the parent controller has it enabled and the navItems
        // will inherit the parent's preference for title display
        navigationItem.largeTitleDisplayMode = .never
        
        // setting the nav controller title to the current checklist's name
        // is this safe? Found nil and crashed without proper segue -- will this never be nil when properly setup?
        title = checklist.name
        
        //loading the plist of saved 'items' array for data persistence
        loadChecklistItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            // edits the array item for the data source
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
            
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
        saveChecklistItems()
    }
    
    // swipe to delete delegate method
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //remove from data model ('items' array)
        items.remove(at: indexPath.row)
        
        //remove from the table view
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveChecklistItems()
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        // tag is used here instead of an @IBOutlet since the element is reusable and has multiple instances
        let label = cell.viewWithTag(1000) as! UILabel
        
        //replace each item with text
        label.text = item.text
    }
    
    //sets initial state of togglable checkmark when row is drawn to cell -- fixes reused cell bug
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked == true {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        // get new final row index
        let newRowIndex = items.count
        // add to data source array
        items.append(item)
        
        // add new row to tableView
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        // get index of itemToEdit in array of data source
        if let index = items.index(of: item) {
            // convert Int row into IndexPath
            let indexPath = IndexPath(row: index, section: 0)
            // conmsume indexpath to find correct cell to modify
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    //book suggested their own helper method for getting the doc dir of the app since none is provided
    func documentsDirectory() -> URL {
        //returns the path for the users document folder
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //return first and only el of the arr
        return paths[0]
    }
    
    //method to chain on 'documentsDirectory()' to grab the right file path for saving
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // encode obj array and save items to documents folder in a plist
    func saveChecklistItems() {
        // create the encoder - list format
        let encoder = PropertyListEncoder()
        // do-catch try block - encode items array into file list and write to file
        do {
            //encode data
            let data = try encoder.encode(items)
            //write data to plist file
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array!")
        }
    }
    
    //adding a func to load the plist array
    func loadChecklistItems() {
        // set path for plist
        let path = dataFilePath()
        //if guard to get the data at the path
        if let data = try? Data(contentsOf: path) {
            // create decoder
            let decoder = PropertyListDecoder()
            do {
                // decode items to populate the 'items' array
                items = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("Error decoding item array!")
            }
        }
    }
}
