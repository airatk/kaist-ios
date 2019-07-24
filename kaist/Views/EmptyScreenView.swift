//
//  EmptyScreenView.swift
//  kaist
//
//  Created by Airat K on 17/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class EmptyScreenView: UIView {

    private var emoji = UILabel()
    private var message = UILabel()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(emoji: String, message: String) {
        super.init(frame: .zero)
        
        self.setUpEmojiView(using: emoji)
        self.setUpMessageView(using: message)
    }
    
    
    private func setUpEmojiView(using emoji: String) {
        self.emoji.text = emoji
        self.emoji.font = .systemFont(ofSize: 64)
        self.emoji.textAlignment = .center
        
        self.addSubview(self.emoji)
        
        self.emoji.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            self.emoji.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.emoji.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setUpMessageView(using message: String) {
        self.message.text = message
        self.message.font = .systemFont(ofSize: 16)
        self.message.textColor = .gray
        self.message.textAlignment = .center
        
        self.addSubview(self.message)
        
        self.message.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            self.message.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.message.topAnchor.constraint(equalTo: self.emoji.bottomAnchor, constant: 10)
        ])
    }

}
