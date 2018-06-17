//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 5/15/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit

// setup to create delegate
protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    //outlet variable exposed at the class level
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var itemToEdit: ChecklistItem?
    
    var dueDate = Date()
    
    // delegate to allow the add item vc to return the field text to prior screen
    weak var delegate: ItemDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        // loads the edit page instead -- uses "variable shadowing"? Might be the wrong term for this case
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            textField.text = itemToEdit.text
            // should be able to submit the edited item without change -- better UX
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - Misc functions
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
        
//        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done() {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: itemToEdit)
        } else {
            let item = ChecklistItem(text: textField.text!, checked: false)
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
        // debug
//        print("Textfield is currently '\(textField.text!)'")
//
//        navigationController?.popViewController(animated: true)
    }
    
    func updateDueDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
    }
    
    // MARK: - Text Field Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)

        // disables done bar if text field is empty -- enables if not empty
        doneBarButton.isEnabled = !newText.isEmpty
        
        // can be replaced with the above snippet -- clever and concise!
//        if newText.isEmpty {
//            doneBarButton.isEnabled = false
//        } else {
//            doneBarButton.isEnabled = true
//        }
        return true
    }
}
