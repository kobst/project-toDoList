//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Edward Han on 11/15/16.
//  Copyright © 2016 Edward Han. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    
    
    @IBOutlet weak var descript: UILabel!
    
    
    @IBOutlet weak var doneLabel: UILabel!
    
    var task: Task!
    
    
    func didSwipe(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.ended {
            doneLabel.isHidden = !doneLabel.isHidden
        }
        
        task.done = !task.done
        
    }
    
    
//    func didPress(recognizer: UILongPressGestureRecognizer) {
//        
//        
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        let recognizer = UISwipeGestureRecognizer(target: self, action:#selector(didSwipe(recognizer:)))
        contentView.addGestureRecognizer(recognizer)

       
//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(longPressed(longPressRecognizer:)))
//        contentView.addGestureRecognizer(longPressRecognizer)

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
