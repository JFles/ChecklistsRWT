//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 5/11/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import Foundation

// inherited NSObject to add "equatable" properties to object
class ChecklistItem: NSObject {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
