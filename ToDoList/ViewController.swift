//
//  ViewController.swift
//  ToDoList
//
//  Created by Edward Han on 11/15/16.
//  Copyright © 2016 Edward Han. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return List.allLists.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item  = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListViewCell
        
        item.listTitle.text = List.allLists[indexPath.row].title
        
        
        
        var doneTasks = 0
        for task in List.allLists[indexPath.row].tasks {
            if task.done { doneTasks += 1}
        }
        
        item.counter.text = "\(doneTasks)" + "/" + "\(List.allLists[indexPath.row].tasks.count)" + "   done"
        
        
        return item
        
    }
    
    
    @IBOutlet weak var listName: UITextField!
    
    @IBOutlet weak var ToDoLists: UITableView!
    
    @IBOutlet weak var addListButton: UIButton!
    @IBAction func addList(_ sender: UIButton) {
//        if List.allLists.count > 0 {
//        selectedListIndex = selectedListIndex + 1
//        selectedTaskIndex = 0
//    }
        
       
        
//        print(List.allLists.count)
//        print(selectedListIndex)
//        print(List.allLists.count)
//        print(List.allLists)
        let titleField = listName.text
        let newList = List(title: titleField!, tasks: [])
        selectedListIndex = newList.listIndex
        performSegue(withIdentifier: "toListDetail", sender: nil)
        
    }
    
//    
//    @IBAction func goToList(_ sender: UIButton) {
//        guard let checkIndex = ToDoLists.indexPathForSelectedRow else {return}
//        
//        
//        selectedListIndex = checkIndex.row
//        
//        performSegue(withIdentifier: "toListDetail", sender: nil)
//    }
//    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            List.allLists.remove(at: indexPath.row)
            self.ToDoLists.reloadData()
    
            }
        }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addListButton.isEnabled = true
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ItemIndex = ToDoLists.indexPathForSelectedRow {
            selectedListIndex = ItemIndex.row
            performSegue(withIdentifier: "toListDetail", sender: nil)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.ToDoLists.reloadData()
        listName.text = ""
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listName.text = ""
        addListButton.isEnabled = false
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

