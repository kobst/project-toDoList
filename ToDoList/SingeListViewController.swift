//
//  SingeListViewController.swift
//  ToDoList
//
//  Created by Edward Han on 11/15/16.
//  Copyright © 2016 Edward Han. All rights reserved.
//

import UIKit

class SingeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var counter = 0
    
    @IBOutlet weak var singleList: UITableView!
    
  
    @IBOutlet weak var listName: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if List.allLists.count > 0 {
            return List.allLists[selectedListIndex].tasks.count
        }
        else {
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = singleList.dequeueReusableCell(withIdentifier: "taskItem") as! TaskTableViewCell
        
                
        item.title.text = List.allLists[selectedListIndex].tasks[indexPath.row].title
        
        item.descript.text = List.allLists[selectedListIndex].tasks[indexPath.row].descr
        
        item.task = List.allLists[selectedListIndex].tasks[indexPath.row]
        
        if List.allLists[selectedListIndex].tasks[indexPath.row].done == false {
            
             item.doneLabel.isHidden = true
        }
       
        else {
            
              item.doneLabel.isHidden = false
        }
        
        
        return item
        
    }
    
    
//    @IBAction func save(_ sender: Any) {
//        if ListTitle.text != "" {
//            List.allLists[selectedListIndex].title = ListTitle.text!
//        }
//        else {
//            ListTitle.text = "please enter name of list"
//            
//        }}
    
    
//    @IBAction func editTask(_ sender: UIButton) {
//        if let ItemIndex = singleList.indexPathForSelectedRow {
//            selectedTaskIndex = ItemIndex.row
//            performSegue(withIdentifier: "toEditTask", sender: nil)
//        }
//        else {return}
//    }
//    
    
    
    
    @IBAction func addTask(_ sender: UIButton) {
        
        selectedTaskIndex = List.allLists[selectedListIndex].tasks.count
        
        performSegue(withIdentifier: "toAddTask", sender: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ItemIndex = singleList.indexPathForSelectedRow {
            selectedTaskIndex = ItemIndex.row
            performSegue(withIdentifier: "toEditTask", sender: nil)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditTask"  {
            let taskDetail = segue.destination as! TaskDetailViewController
            
            taskDetail.task = List.allLists[selectedListIndex].tasks[selectedTaskIndex]
//            taskDetail.taskTitle.text = List.allLists[selectedListIndex].tasks[selectedTaskIndex].title
//            
//            
//            taskDetail.taskDescription.text = List.allLists[selectedListIndex].tasks[selectedTaskIndex].descr
            
            //            print(List.allLists[selectedListIndex].tasks[selectedTaskIndex].title)
            //            print(List.allLists[selectedListIndex].tasks[selectedTaskIndex].descr)
            
        }
        
    }
    //
    
    
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "toEditTask" {
    ////            let taskDetail = segue.destination as! TaskDetailViewController
    //
    //            taskEditing = true
    //        }
    //        if segue.identifier == "toAddTask" {
    //            taskEditing = false
    //        }
    ////            taskDetail.taskTitle.text = List.allLists[selectedListIndex].tasks[selectedTaskIndex].title
    //            taskDetail.taskDescription.text = List.allLists[selectedListIndex].tasks[selectedTaskIndex].descr
    
    






//                }
//
//                else {
//
//                    destination.taskTitle.text = List.allLists[selectedListIndex].tasks[selectedTaskIndex].title
//
//                    destination.taskDescription.text = List.allLists[selectedListIndex].tasks[selectedTaskIndex].descr
//                }
//







func textFieldShouldReturn(textField: UITextField) -> Bool {
    listName.endEditing(true)
    return false
}




override func viewWillAppear(_ animated: Bool) {
    self.singleList.reloadData()
    //        guard let list = List.allLists[selectedListIndex] else {}
    if List.allLists.count > 0 {
        listName.text = List.allLists[selectedListIndex].title
        
    }
}


    
    

    
    
    
    
    @IBOutlet var swiped: UISwipeGestureRecognizer!
    
    
    
    

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
