//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 5/11/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import Foundation

// inherited NSObject to add "equatable" properties to object
// inherited Codable to allow encode/decode (serialization) for saving
class ChecklistItem: NSObject, Codable {
    init(text: String, checked: Bool = false) {
        self.text = text
        self.checked = checked
        super.init()
    }
    
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
