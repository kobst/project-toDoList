//
//  data.todolist.swift
//  ToDoList
//
//  Created by Edward Han on 11/15/16.
//  Copyright © 2016 Edward Han. All rights reserved.
//

import Foundation
import UIKit

var selectedListIndex: Int = 0
var selectedTaskIndex: Int = 0


var taskEditing: Bool = false




class Model {
    
    static let shared = Model()
    private init() {}
    let key = "lists"
    
    func persistListsToDefaults() {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: getLists())
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func loadPersistedListsFromDefaults() {
        
        if let data = UserDefaults.standard.object(forKey: key) as? Data {
            let lists = NSKeyedUnarchiver.unarchiveObject(with: data) as! [List]
            print(lists)
        }
    }
    
    func persistListsToFile() {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: getLists())
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileUrl = docsURL?.appendingPathComponent(key)
        if FileManager.default.fileExists(atPath: fileUrl!.path) {
            do {
                try data.write(to: fileUrl!, options: .atomic)
            } catch {
                print(error)
            }
        } else {
            FileManager.default.createFile(atPath: fileUrl!.path, contents: data, attributes: nil)
        }
    }
    
    func loadPersistedListsFromFile() {
        
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileUrl = docsURL?.appendingPathComponent(key)
        do {
            let data = try Data(contentsOf: fileUrl!)
            let lists = NSKeyedUnarchiver.unarchiveObject(with: data) as! [List]
            print(lists)
        } catch {
            print(error)
        }
    }
    
    func getJSONFromBundle() -> String? {
        
        if let url = Bundle.main.url(forResource: "valid", withExtension: "json") {
            return try? String(contentsOf: url, encoding: .utf8)
        }
        return nil
    }
    
    func getLists() -> [List] {
        return List.allLists
    }
}





class Task: NSObject, NSCoding {
    
    private struct Keys {
        static let title = "name"
        static let descr = "age"
        static let done = "isHappy"
    }
    
    var title: String
    var descr: String
    var done: Bool
    init(title: String, descr: String, done: Bool = false) {
        self.title = title
        self.descr = descr
        self.done = done
    }
    
    required convenience init?(coder aDecoder: NSCoder ) {
        self.init(
            title: aDecoder.decodeObject(forKey: Keys.title) as! String,
            descr: aDecoder.decodeObject(forKey: Keys.descr) as! String,
            done: aDecoder.decodeBool(forKey: Keys.done)
        )
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: Keys.title)
        aCoder.encode(descr, forKey: Keys.descr)
        aCoder.encode(done, forKey: Keys.done)
    }
    
}


class List: NSObject, NSCoding {
    
    private struct Keys {
        static let title = "title"
        static let listIndex = "listIndex"
        static let tasks = "tasks"
    }
    
    
    static var allLists = [List] ()
    
    var listIndex: Int
    var title: String
    var tasks = [Task]()
    
    
    init(title: String, tasks: [Task]) {
        self.title = title
        self.tasks = tasks
        self.listIndex = List.allLists.count
        super.init()
        List.allLists.append(self)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(
            title: aDecoder.decodeObject(forKey: Keys.title) as! String,
            tasks: aDecoder.decodeObject(forKey: Keys.tasks) as! [Task]
        )
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: Keys.title)
        aCoder.encode(tasks, forKey: Keys.tasks)
    }
    
    
}







