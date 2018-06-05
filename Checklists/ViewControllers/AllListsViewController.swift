//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 5/31/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    //initialized array to hold the checklists
    var lists = [Checklist]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // seems this should only be set for the initial parent view
        // and additional vcs in the stack should only set the 'navigationItem' prop
        navigationController?.navigationBar.prefersLargeTitles = true

        // using local data persistence w/ plist
        loadChecklistItems()
        
//        // setting test seed data for lists
//        // MARK: - Seed Test Data for lists
//        var list = Checklist(name: "Clothing")
//        lists.append(list)
//
//        list = Checklist(name: "Recipes")
//        lists.append(list)
//
//        list = Checklist(name: "Dinners")
//        lists.append(list)
//
//        list = Checklist(name: "Activities")
//        lists.append(list)
//
//        // seeding each list with records
//        //for each list in lists
//        for list in lists {
//            //create a while or repeat-while loop to generate multiple items per list
//            var counter = 1
//            while counter <= 10 {
//                // create new checklist item object
//                let item = ChecklistItem()
//                // add text to the item
//                item.text = "Item # \(counter) for \(list.name)"
//                // append the item to the 'items' array in the checklist
//                list.items.append(item)
//                counter += 1
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
        // replacing hard coded row count lists array count
        return lists.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // store the current checklist object so that it can be passed to the Checklist View Controller
        let checklist = lists[indexPath.row]
        // manually segue to the checklist VC
        performSegue(withIdentifier: "ShowChecklist", sender: checklist) // establishes the sender prop on 'self'
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creating prototype cell in code - not using IB!
//        let cell = makeCell(for: tableView)
//        cell.textLabel!.text = "List \(indexPath.row)"
        
        let cell = makeCell(for: tableView)
        
        // get checklist item from data source to configure cell
        let checklist = lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    // delegate method to allow 'swipe-to-delete'
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //remove the object from the data source array
        lists.remove(at: indexPath.row)
        //delete rows from the tableView
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //loading a view controller from code instead of an IB segue
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //create controller
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        
        //set delegate
        controller.delegate = self
        
        // set the 'ChecklistToEdit' object
        let checklist = lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        // push new VC to nav stack
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // method allows parent VC to set up initial data for new VC before it renders
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // verify that the segue is from checklists to a specific checklist
        if segue.identifier == "ShowChecklist" {
            // grab a reference to the destination segue and cast as the proper VC
            let controller = segue.destination as! ChecklistViewController
            // finally, set the exposed 'checklist' var in the Checklist VC to the sender 'Checklist' object
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            // set ListDetailViewController as the destination
            let controller = segue.destination as! ListDetailViewController
            // set self as delegate
            controller.delegate = self
        }
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        
        // returns recyclable cell for reuse if a reusable cell exists
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
        // returns a new recyclable cell
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
    }
    
    // MARK: - ListDetailViewDelegate Methods
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        // create new index to use for updating tableView
        let newRowIdex = lists.count
        // append to array data source
        lists.append(checklist)
        
        //create new indexpath obj
        let indexPath = IndexPath(row: newRowIdex, section: 0)
        //make const array with new indexpath
        let indexPaths = [indexPath]
        // add indexpath arr to tableview
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        //pop nav stack
        navigationController?.popViewController(animated: true)
    }
    
    // TODO: - REVIEW HOW THIS WORKS
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        // grab index of array item to edit
        if let index = lists.index(of: checklist) {
            // use index to ref the proper Index Path in the tableView
            let indexPath = IndexPath(row: index, section: 0)
            // grab cell to edit
            if let cell = tableView.cellForRow(at: indexPath) {
                // set cell text label the same as the checklist object
                cell.textLabel!.text = checklist.name
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Persistence Functions
    // helper method for getting the doc dir of the app since none is provided
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
            let data = try encoder.encode(lists)
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
                lists = try decoder.decode([Checklist].self, from: data)
            } catch {
                print("Error decoding item array!")
            }
        }
    }
}
