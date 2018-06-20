//
//  Checklist.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 6/4/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
    init(name: String, iconName: String = "Folder") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    // will hold the name of the checklist
    var name = ""
    
    //holds the icon filename for the checklist -- Default is "Appointments" icon
    var iconName = "No Icon"
    
    // nesting the checklist item array inside the checklist array
    var items = [ChecklistItem]()

    // returns the number of remaining unchecked items
    func countItems() -> Int {
        /*
        // original approach
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
        */
        //functional approach
        return items.reduce(0) { count, item in count + (!item.checked ? 1 : 0) }
    }
    
    // dueDate sorting
    func sortChecklistItems() {
        // FIXME: - This works, but can it be refactored?
        items.sort(by: { item1, item2 in return
            item1.shouldRemind == true && item2.shouldRemind == false &&
            item1.dueDate.compare(item2.dueDate) == .orderedAscending ||
            item1.shouldRemind == true && item2.shouldRemind == true &&
            item1.dueDate.compare(item2.dueDate) == .orderedAscending
        })
    }
}
