//
//  EmptyScheduleScreen.swift
//  kaist
//
//  Created by Airat K on 17/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class EmptyScheduleScreen: UIView {

    private var emoji: UILabel!
    private var message: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setUpEmojiView(using: "🙅🏼‍♀️")
        self.setUpMessageView(using: "Расписания нет")
    }
    
    
    private func setUpEmojiView(using emoji: String) {
        self.emoji = UILabel()
        
        self.emoji.text = emoji
        self.emoji.font = .systemFont(ofSize: 64)
        self.emoji.textAlignment = .center
        
        self.addSubview(self.emoji)
        
        self.emoji.translatesAutoresizingMaskIntoConstraints = false
        self.emoji.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.emoji.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setUpMessageView(using message: String) {
        self.message = UILabel()
        
        self.message.text = message
        self.message.font = .systemFont(ofSize: 16)
        self.message.textColor = .gray
        self.message.textAlignment = .center
        
        self.addSubview(self.message)
        
        self.message.translatesAutoresizingMaskIntoConstraints = false
        self.message.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.message.topAnchor.constraint(equalTo: self.emoji.bottomAnchor, constant: 10).isActive = true
    }

}
