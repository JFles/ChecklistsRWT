//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 5/15/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit
import UserNotifications

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
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var itemToEdit: ChecklistItem?
    
    // creates a date obj initialized with current date and time
    // need an instance variable because label is stored as a string which is harder to read from
    var dueDate = Date()
    // tracks whether the datePicker should be shown for the reminder section
    var datePickerVisible = false
    
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
            shouldRemindSwitch.isOn = itemToEdit.shouldRemind
            dueDate = itemToEdit.dueDate
        }
        // called here to set the due date label with the proper format and with the current time/date
        updateDueDateLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        textField.becomeFirstResponder()
    }
    
    //MARK: - TableView Delegate Methods
    // prevent row highlight on cell select in code
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // make the dateLabel cell selectable
        if indexPath.row == 1 && indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible == true {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        
        if indexPath.row == 1 && indexPath.section == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.row == 2 && indexPath.section == 1 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 && indexPath.section == 1 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    // MARK: - Misc functions
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
        
//        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done() {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            itemToEdit.shouldRemind = shouldRemindSwitch.isOn
            itemToEdit.dueDate = dueDate
            itemToEdit.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishEditing: itemToEdit)
        } else {
            let item = ChecklistItem(text: textField.text!, checked: false)
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    // listener event for datepicker outlet to update local dueDate variable
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    // request permissions for alerts if reminder switch is on
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        tableView.resignFirstResponder()
        
        if shouldRemindSwitch.isOn {
            let navigationCenter = UNUserNotificationCenter.current()
            navigationCenter.requestAuthorization(options: [.alert, .sound]) {
                granted, error in
                // do nothing
            }
        }
    }
    
    func updateDueDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dueDateLabel.text = dateFormatter.string(from: dueDate)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        // because two operations are occurring at once, have to be wrapped in the begin and end calls so that they are animated at the same time
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        // have to set the date based on obj prop for edited items
        datePicker.setDate(dueDate, animated: false)
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePickerRow = IndexPath(row: 2, section: 1)
            
            if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
                dateCell.detailTextLabel!.textColor = UIColor.black
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePickerRow], with: .fade)
            tableView.endUpdates()
        }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
}
