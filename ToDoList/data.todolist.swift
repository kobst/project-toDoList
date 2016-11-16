//
//  data.todolist.swift
//  ToDoList
//
//  Created by Edward Han on 11/15/16.
//  Copyright © 2016 Edward Han. All rights reserved.
//

import Foundation
import UIKit


class Task {
    
    var title: String
    var descr: String
    var done = false
    init(title: String, descr: String) {
        self.title = title
        self.descr = descr
    }
}



class List {
    static var allLists = [List] ()
    var listIndex: Int
    var title: String
    var tasks = [Task]()
//    var doneTasks = 0
//    static var doneTasks: Int {
//        var counter = 0
//        for task in tasks {
//            counter + = (task.done ?? 1 : 0)
//        }
//        return counter
//    }

    init(title: String, tasks: [Task]) {
        self.title = title
        self.tasks = tasks
        self.listIndex = List.allLists.count
        List.allLists.append(self)
    }
    
}


var selectedListIndex: Int = 0
var selectedTaskIndex: Int = 0


var taskEditing: Bool = false


//var selectedList: List


//var selectedList = List(title: "test", tasks: [])

