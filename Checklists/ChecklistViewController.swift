//
//  ViewController.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 5/9/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableView {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: IndexPath)
        
        return cell
    }


}

