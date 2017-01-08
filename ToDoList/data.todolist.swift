//
//  data.todolist.swift
//  ToDoList
//
//  Created by Edward Han on 11/15/16.
//  Copyright © 2016 Edward Han. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

var selectedListIndex: Int = 0
var selectedTaskIndex: Int = 0
var taskEditing: Bool = false




class Model {
    
    static let shared = Model()
    private init() {}
    let key = "lists"
    
    
  
    
    var closure: (()->())?
    
    var currentUserPath = String()
    
    func getJSONFromBundle() -> String? {
        
        if let url = Bundle.main.url(forResource: "valid", withExtension: "json") {
            return try? String(contentsOf: url, encoding: .utf8)
        }
        return nil
    }
    
    func getLists() -> [List] {
        return List.allLists
    }
    
    
    
    

    

    
    
    func signout() {
        if FIRAuth.auth()?.currentUser != nil {
            
            let firebaseAuth = FIRAuth.auth()
            do {
                try firebaseAuth?.signOut()
                print("signed out")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            
        }
            
            
        else {
            print("no current user")
        }
        
        
    }

    
    
    
    func createUserList(uid: String, name: String) {
        
        let usersRef = FIRDatabase.database().reference()
        
        let userRef = usersRef.child(uid)
        
        userRef.setValue([
            "name": name,
//            "lists": [List]()
            "lists": 0
            ])
        
    }
    
    
    func printUserName(uid: String) {
        let usersRef = FIRDatabase.database().reference(withPath: "users")
        
        
        //        let query = usersRef.queryEqual(toValue: uid)
        

        usersRef.observeSingleEvent(of: .value, with: {snapshot in
            
            if snapshot.hasChildren() {
                
                for child in snapshot.children {
                    let entry = child as! FIRDataSnapshot
                    if entry.key == uid {
                        print(entry.value ?? 0)
                    }
                    
                }
            }
            
            
        })
        
    }
    
    
    
    
    
    func createList(title: String, content: [Task]) {
        
        let listsRef = FIRDatabase.database().reference(withPath: "\(currentUserPath)/lists")
        let list = List(title: title, tasks: content)
        let listRef = listsRef.child(title)
        
        listRef.setValue(list.toAnyObject())
    }
    

    
//    func createList2(list: List) {
//        
//        let listsRef = FIRDatabase.database().reference(withPath: "lists")
//        let listRef = listsRef.child(list.title)
//        listRef.setValue(list.toAnyObject())
//        
//    }
    
    
    func deleteList(list: List) {
        
        list.ref.removeValue()
    }
    
    
    func listenForNotes(complete: @escaping ()->()) {
        
        closure = complete
        // queryOrdered(byChild: "completed")
        let lists = FIRDatabase.database().reference(withPath: "\(currentUserPath)/lists")
        lists.observe(.value, with: didUpdateNotes)
    }
    
    func listenForNotesUser(complete: @escaping ()->()) {
        
        closure = complete
        // queryOrdered(byChild: "completed")
        let lists = FIRDatabase.database().reference(withPath: currentUserPath)
        lists.observe(.value, with: didUpdateNotes)
    }
    
    
    func didUpdateNotes(snapshot: FIRDataSnapshot) {
        
        List.allLists.removeAll()
        
        for item in snapshot.children {
            let _ = List(snapshot: item as! FIRDataSnapshot)
            
        }
        
        // TODO : tell vc to reload table view dta
        closure?()
        closure = nil
    }
    
    
    
    func updateList(newTitle: String, content: [Task], list: List) {
        if list.title == newTitle {

            let tasksRef = FIRDatabase.database().reference(withPath: "\(currentUserPath)/lists/\(list.title)/tasks")
            
            for task in content {
                let taskRef = tasksRef.child(task.title)
                taskRef.setValue(task.toAnyObject())
            }
//            list.ref.updateChildValues([
//                "tasks": values,
//                "index": list.listIndex
//                ])
        }
        
        else {
            list.ref.removeValue()
            createList(title: newTitle, content: content)
        }
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
    
 
    init(snapshot: FIRDataSnapshot) {
        self.title = snapshot.key
        let values = snapshot.value as! [String: AnyObject]
        self.descr = values["descr"] as! String
        self.done = values["done"] as! Bool
        
        
//        self.descr = snapshot.value as! String
//        self.done = false
        
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
    
    
    func toAnyObject() -> Any {
        return [
        "descr": descr,
        "done": done
        ]
    }
    
}


class List {
    
    private struct Keys {
        static let title = "title"
        static let listIndex = "listIndex"
        static let tasks = "tasks"
    }
    
    
    static var allLists = [List] ()
    
    var listIndex: Int
    var title: String
    var tasks = [Task]()
    var ref = FIRDatabaseReference()
    
    
    init(snapshot: FIRDataSnapshot) {
        self.title = snapshot.key
        
        
        let values = snapshot.value as! [String: AnyObject]
        
        self.listIndex = values["index"] as! Int
//        self.tasks = value["tasks"] as! [Task]
//        let taskDict = values["tasks"] as! [FIRDataSnapshot]
        
        let tasksSS = snapshot.childSnapshot(forPath: "tasks")
        
        if let zero = tasksSS.value as? Int {
            self.tasks = []
            self.ref = snapshot.ref
            
        }
        
        
        else {
            
            let taskDict = values["tasks"] as! [String : Any]
            
            var tasks = [Task]()
            for snaps in taskDict {
                //            let task = Task(snapshot: snaps)
                
                
                let title = snaps.key
                let details = snaps.value as! [String: Any]
                let descr = details["descr"]
                let done = details["done"]
                let task = Task(title: title, descr: descr as! String, done: done as! Bool)
                tasks.append(task)
            }
            
            self.tasks = tasks
            self.ref = snapshot.ref
            
        }

        
        
//        var taskList = [Task]()
//        for (key, value) in tasks {
//            let taskName = key
//            let values = value as! [String:String]
//            let taskDescription = values["description"]! as String
//            let taskDone = (values["done"] != nil) as Bool
//            let taskItem = Task(title: taskName, descr: taskDescription, done: taskDone)
//            taskList.append(taskItem)
//        }
        

        
        List.allLists.append(self)
    }
    
    init(title: String, tasks: [Task]) {
        self.title = title
        self.tasks = tasks
        self.listIndex = List.allLists.count
//        super.init()
        List.allLists.append(self)
    }
    
    

    
    func toAnyObject() -> Any {   // need to figure out a way to return the task array....
        if tasks.isEmpty {
            return ["tasks": 0,
                    "index": listIndex
                    ]
        }
            
        else {
            var values = [String: Any]()
            for task in tasks {
                values[task.title] = task.toAnyObject()
            }
            return ["tasks": values,
                    "index": listIndex]
        }
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
    
    
    
    
    
    
    
    class ExampleNote {
        var message: String
        var language: String
        init(snapshot: FIRDataSnapshot) {
            let data = snapshot.value as! [String: String]
            self.message = data["message"]!
            self.language = data["language"]!
            
            //            let messagePair = snapshot.childSnapshot(forPath: "message")
            //            message = messagePair.value as! String
            //
            //            let languagePair = snapshot.childSnapshot(forPath: "language")
            //            language = languagePair.value as! String
            //            self.message = snapshot.value(forKey: "message") as! String
            //            self.language = snapshot.value(forKey: "language") as! String
        }
    }
    class KeyValue {
        var key: String
        var value: Any
        init(key: String, value: Any) {
            
            self.key = key
            
            self.value = value
        }
        
        init(snapshot: FIRDataSnapshot) {
            
            self.key = snapshot.key
            self.value = snapshot.value as! String
        }
        
    }
    
    
    func createListMockExercise(keys: KeyValue) {
        
        let listsRef = FIRDatabase.database().reference()
        
        let listRef = listsRef.child(keys.key)
        
        listRef.setValue(keys.value)
        
        print(listsRef.key)
    }
    
    
    
  
        
        //        print(usersRef.description())
        //        let userRef = usersRef.child(uid)
        //        let name = userRef.value(forKey: uid)
        ////        messageRef.setValue("hello")
        //        print(name ?? "no exist")
        
   
    
    
    //        usersRef.queryOrderedByChild("Interest").queryEqualToValue("men").
    //        (.Value, withBlock: { snapshot in
    //
    //            for child in snapshot.children {
    //
    //                if child.k
    //
    //                let name = child.value[uid]
    //                print(name)
    
    
    
    
    
    
    
    
    
    func listemForNotesMock(value: String) {
        
        let lists = FIRDatabase.database().reference(withPath: "messages")
        lists.observe(.value, with: { snapshot in
            //            print(snapshot.key)
            //            print(snapshot.value ?? 0)
            //
            //
            //            print(snapshot.key)
            //            print(snapshot.value ?? 0)
            
            self.didUpdateNotesMock(snapshot: snapshot)
            
        })
    }
    
    
    func listenForData(){
        let ref = FIRDatabase.database().reference(withPath: "data")
        ref.observe(.value, with: { snapshot in
            self.didupdateData(snap: snapshot)
            
        }   )
    }
    
    //    func listenForData(){
    //        let ref = FIRDatabase.database().reference(withPath: "data")
    //        ref.observe(.value, with: { snapshot in
    //            self.didupdateData(snap: snapshot)
    //
    //        }   )
    //    }
    
    
    
    
    
    var dataArray = [KeyValue]()
    
    var exampleArray = [ExampleNote]()
    
    func didupdateData(snap: FIRDataSnapshot) {
        
        if snap.hasChildren() {
            print("in hasChildren")
            for child in snap.children {
                let entry = child as! FIRDataSnapshot
                //                print(entry.key)
                //                print(entry.value ?? 0)
                //                let newData = KeyValue(snapshot: entry)
                //                dataArray.append(newData)
                
                
                let example = ExampleNote(snapshot: entry)
                exampleArray.append(example)
                
                
                
                
                
                
                
                
            }
            
            
        }
            
        else {
            print(snap.key)
            print(snap.value ?? "nothing")
            dataArray = []
        }
        
        for example in exampleArray {
            print("\(example.message)....\(example.language)......")
            
            
        }
        
        //       print
        
        
        
    }
    
    
    func changeData() {
        
        let ref = FIRDatabase.database().reference(withPath: "data")
        //        ref.setValue(value)
        
        
        let messageRef = ref.child("message")
        messageRef.setValue("hello")
        let languageRef = ref.child("language")
        languageRef.setValue("english")
        
        
        
    }
    
    
    func didUpdateNotesMock(snapshot: FIRDataSnapshot) {
        
        print(snapshot.key)
        print(snapshot.value ?? 0)
        
        //        for item in snapshot.children {
        //            let list = KeyValue(snapshot: item as! FIRDataSnapshot)
        //            print(list.key)
        //            print(list.value)
        //        }
        
        // TODO : tell vc to reload table view dta
        
    }
    
    
    func updateValueMock(value: String){
        
        let messageRef = FIRDatabase.database().reference(withPath: "messages")
        
        messageRef.setValue(value)
        
    }
    
    
    
    func updateListMock(newTitle: String) {
        let messageRef = FIRDatabase.database().reference(withPath: "messages")
        
        messageRef.setValue(newTitle)
        
        
    }
    
    

    
    
}







//        listenForData()
//        changeData()


//        let dataRef = FIRDatabase.database().reference(withPath: "data")
//
//        let message1 = dataRef.childByAutoId()
//        message1.setValue([
//            "message": "hello",
//            "language": "english"
//            ])
//
//        let message2 = dataRef.childByAutoId()
//        let m2m = message2.child("message")
//        m2m.setValue("bye")
//        let m21 = message2.child("language")
//        m21.setValue("english")
//
//
//        let message3 = dataRef.childByAutoId()
//        message3.setValue([
//            "message": "hola",
//            "language": "spanish"
//            ])








//        let ref = FIRDatabase.database().reference(withPath: "foo")

//        ref.ref.removeValue()

//        ref.removeValue()



//        listemForNotesMock(value: "new string")


//        createListMockExercise(keys: example2)










