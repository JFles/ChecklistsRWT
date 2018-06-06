//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 5/31/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController,
                              ListDetailViewControllerDelegate,
                              UINavigationControllerDelegate {
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // seems this should only be set for the initial parent view
        // and additional vcs in the stack should only set the 'navigationItem' prop
        navigationController?.navigationBar.prefersLargeTitles = true

        // using local data persistence w/ plist
//        loadChecklistItems()
        
        //DEBUG: output documents directory
//        print(documentsDirectory())
    }
    
    //adding viewDidAppear() to handle saving last checklist viewed -- UX improvement
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //set the nav controller delegate to this VC
        navigationController?.delegate = self
        
        //grab the stored index
//        let index = UserDefaults.standard.integer(forKey: "ChecklistIndex")
        let index = dataModel.indexOfSelectedChecklist
        
//        if index != -1 {
        // made this a more robust check to resolve crash when UserDefaults became out of sync with dataModel
        if index >= 0 && index < dataModel.lists.count {
            // set appropriate checklist by index
            let checklist = dataModel.lists[index]
            // segue to correct checklist
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
        // replacing hard coded row count lists array count
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //storing the row indexpath in user defaults to persist current viewed checklist if app terminates
//        UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex")
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        // store the current checklist object so that it can be passed to the Checklist View Controller
        let checklist = dataModel.lists[indexPath.row]
        // manually segue to the checklist VC
        performSegue(withIdentifier: "ShowChecklist", sender: checklist) // establishes the sender prop on 'self'
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Creating prototype cell in code - not using IB!
//        let cell = makeCell(for: tableView)
//        cell.textLabel!.text = "List \(indexPath.row)"
        
        let cell = makeCell(for: tableView)
        
        // get checklist item from data source to configure cell
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    // delegate method to allow 'swipe-to-delete'
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //remove the object from the data source array
        dataModel.lists.remove(at: indexPath.row)
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
        let checklist = dataModel.lists[indexPath.row]
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
        let newRowIndex = dataModel.lists.count
        // append to array data source
        dataModel.lists.append(checklist)
        
        //create new indexpath obj
        let indexPath = IndexPath(row: newRowIndex, section: 0)
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
        if let index = dataModel.lists.index(of: checklist) {
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

    //MARK: - UINavigationControllerDelegate methods
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // checks if the back button is tapped
        // sets the "remembered index" to an invalid value (UserDefaults does not support optionals)
        // whenever the nav VC stack currently shows the initial view(AllListsVC VC)
//        if navigationController.visibleViewController === self {
        if viewController === self {
//            UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}
