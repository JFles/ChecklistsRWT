//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 6/4/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import Foundation
import UIKit

// needed for delegate pattern
protocol ListDetailViewControllerDelegate: class {
    // user taps cancel button
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    // user adds new checklist
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    // user edits existing checklist
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

// allows adding and editing of checklists
class ListDetailViewController: UITableViewController,
                                UITextFieldDelegate,
                                IconPickerViewControllerDelegate {
    // expose: text field and done button
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    //add delegate reference for pattern
    weak var delegate:ListDetailViewControllerDelegate?
    
    // add var for editing checklists
    var checklistToEdit: Checklist?
    
    // icon name for checklist icon image
    var iconName = "Folder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //disable large title for the nav item
        navigationItem.largeTitleDisplayMode = .never
        
        // set VC for editing if checklistToEdit is set
        if let checklistToEdit = checklistToEdit {
            //set title
            title = "Edit Checklist"
            //prefill text field for editing
            textField.text = checklistToEdit.name
            //enable done bar if no change -- override for algorithm preventing empty submissions
            doneBarButton.isEnabled = true
            // set the icon correctly
            iconName = checklistToEdit.iconName
        }
        iconImageView.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //opens keyboard and sets focus to textfield -- better UX
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
//        navigationController?.popViewController(animated: true)
        //reference delegate didCancel
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        // if editing checklist
        if let checklistToEdit = checklistToEdit {
            // update the checklist text from the field
            checklistToEdit.name = textField.text!
            checklistToEdit.iconName = iconName
            // call delegate
            delegate?.listDetailViewController(self, didFinishEditing: checklistToEdit)
        } else { // if not editing
            // create the object
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            // call delegate method
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    // MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // prevent user from highlighting cell on tap instewad of selecting textbox
        // updated to allow user to access sect 1 ui image icons 
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    // MARK: - Icon Picker VC Delegate
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITextField Delegates
    // used to disable done button when the field is empty
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //setup to grab the current text in the field
        let oldText = textField.text!
        //get range(representation of length?) for the existing string
        let stringRange = Range(range, in: oldText)!
        //create new temp string based on current field
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        //set whether the done bar is enabled by whether newText is empty or not
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
}
