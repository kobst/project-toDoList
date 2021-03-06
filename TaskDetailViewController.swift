//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created by Edward Han on 11/15/16.
//  Copyright © 2016 Edward Han. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    
    @IBOutlet weak var listTitle: UILabel!
    
    
    @IBOutlet weak var taskTitle: UITextField!
    
    
    @IBOutlet weak var taskDescription: UITextView!
    
    
    
    var task: Task?
    
    @IBAction func save(_ sender: UIButton) {
//        print(selectedListIndex)
        guard let title = taskTitle.text,
          let descr = taskDescription.text else {
                taskTitle.text = "please enter task name"
                taskDescription.text = "please enter task description"
                return
        }
        
        
        if taskTitle.text == "" {
            taskTitle.text = "please enter task name"
            
        }
        
        
        else {
            
            if taskEditing {
                List.allLists[selectedListIndex].tasks[selectedTaskIndex].title = title
                List.allLists[selectedListIndex].tasks[selectedListIndex].descr = descr
                
            }
            else {
                let newTask = Task(title: title, descr: descr)
                List.allLists[selectedListIndex].tasks.append(newTask)
            }

            
            _ = self.navigationController?.popViewController(animated: true)
        }

//        print(selectedListIndex)
//        print(newTask.title)
//        print(newTask.descr)
        
        print(List.allLists[selectedListIndex].tasks.count)
        
    

        
    }
    
    
    
    func fillLabels() {
        
        listTitle.text = List.allLists[selectedListIndex].title
        taskTitle.text = task?.title
        taskDescription.text = task?.descr
        
        if taskEditing {
            taskTitle.text = List.allLists[selectedListIndex].tasks[selectedTaskIndex].title
            taskDescription.text = List.allLists[selectedListIndex].tasks[selectedTaskIndex].descr
            
        }

        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        fillLabels()
    
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
