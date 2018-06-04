//
//  Checklist.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 6/4/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit

class Checklist: NSObject {
    init(name: String) {
        self.name = name
        super.init()
    }
    
    // will hold the name of the checklist
    var name = ""
}
