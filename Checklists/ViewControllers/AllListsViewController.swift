//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 5/31/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
    //initialized array to hold the checklists
    var lists = [Checklist]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // seems this should only be set for the initial parent view
        // and additional vcs in the stack should only set the 'navigationItem' prop
        navigationController?.navigationBar.prefersLargeTitles = true

        // setting test seed data for lists
        var list = Checklist(name: "Clothing")
        lists.append(list)
        
        list = Checklist(name: "Recipes")
        lists.append(list)
        
        list = Checklist(name: "Dinners")
        lists.append(list)
        
        list = Checklist(name: "Activities")
        lists.append(list)
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
    
    // method allows parent VC to set up initial data for new VC before it renders
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // verify that the segue is from checklists to a specific checklist
        if segue.identifier == "ShowChecklist" {
            // grab a reference to the destination segue and cast as the proper VC
            let controller = segue.destination as! ChecklistViewController
            // finally, set the exposed 'checklist' var in the Checklist VC to the sender 'Checklist' object
            controller.checklist = sender as! Checklist
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
}
