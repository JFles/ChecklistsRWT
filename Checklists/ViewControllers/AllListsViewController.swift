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
    
    // TODO: CHECK THIS OUT! A TODO!
    
    // FIXME: - this is a FIXME
    
    /* removing numberOfSections(in:) ensures there will always be one section in the app */
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
        // replacing hard coded row count lists array count
        return lists.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowChecklist", sender: nil)
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
