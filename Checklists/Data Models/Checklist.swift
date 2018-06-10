//
//  Checklist.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 6/4/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {
    init(name: String) {
        self.name = name
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
    
    
}
