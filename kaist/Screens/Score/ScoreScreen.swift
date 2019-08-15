//
//  ScoreScreen.swift
//  kaist
//
//  Created by Airat K on 2/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class ScoreScreen: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = {
            let tableView = UITableView(frame: .zero, style: .grouped)
            
            tableView.backgroundColor = .white
            tableView.backgroundView = EmptyScreenView(emoji: "✈️", emojiSize: 50, isEmojiCentered: true)
            
            tableView.showsVerticalScrollIndicator = false
            
            //tableView.register(StudentSubjectCell.self, forCellReuseIdentifier: StudentSubjectCell.ID)
            
            return tableView
        }()
        
        self.navigationItem.title = "Баллы"
        
        self.refreshControl = {
            let refreshControl = UIRefreshControl()
            
            refreshControl.addTarget(self, action: #selector(self.refreshScoretable), for: .valueChanged)
            
            return refreshControl
        }()
    }
    
    
    @objc private func refreshScoretable() {
        self.refreshControl?.endRefreshing()
    }
    
}
