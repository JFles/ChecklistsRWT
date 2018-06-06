//
//  DataModel.swift
//  Checklists
//
//  Created by Jeremy Fleshman on 6/5/18.
//  Copyright © 2018 Jeremy Fleshman. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init(){
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    // set "ChecklistIndex" to by -1 default to prevent app crash on new installs
    func registerDefaults() {
        let dictionary: [String : Any] = ["ChecklistIndex": -1,
                                          "FirstTime": true]
        
        // userDefaults will use these values when it cannot find a value in the obj already
        // In the case of "FirstTime"
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    // getter/setter for obj prop
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    func handleFirstTime() {
        // set const for userDef and firstTime val
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        // if firstTime is true
        if firstTime {
            // create a default list
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            // add index to save spot if app terminates
            indexOfSelectedChecklist = 0
            // set firstTime UserDef to false
            userDefaults.set(false, forKey: "FirstTime")
            // call 'sync' function --> Why does this need to be done?
            userDefaults.synchronize()
        }
    }
    
    // MARK: - Data Persistence Functions
    // helper method for getting the doc dir of the app since none is provided
    func documentsDirectory() -> URL {
        //returns the path for the users document folder
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //return first and only el of the arr
        return paths[0]
    }
    
    //method to chain on 'documentsDirectory()' to grab the right file path for saving
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // encode obj array and save items to documents folder in a plist
    func saveChecklists() {
        // create the encoder - list format
        let encoder = PropertyListEncoder()
        // do-catch try block - encode items array into file list and write to file
        do {
            //encode data
            let data = try encoder.encode(lists)
            //write data to plist file
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array!")
        }
    }
    
    //adding a func to load the plist array
    func loadChecklists() {
        // set path for plist
        let path = dataFilePath()
        //if guard to get the data at the path
        if let data = try? Data(contentsOf: path) {
            // create decoder
            let decoder = PropertyListDecoder()
            do {
                // decode items to populate the 'items' array
                lists = try decoder.decode([Checklist].self, from: data)
            } catch {
                print("Error decoding item array!")
            }
        }
    }
}
