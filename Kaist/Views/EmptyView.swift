//
//  EmptyView.swift
//  Kaist
//
//  Created by Airat K on 17/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class EmptyView: UIView {

    private var emoji = UILabel()
    private var message = UILabel()


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(emoji: String? = "🤷🏼‍♀️", message: String? = nil) {
        super.init(frame: .zero)

        self.setUpEmojiView(using: emoji)
        self.setUpMessageView(using: message)
    }

    init(emojiAtCenter emoji: String) {
        super.init(frame: .zero)

        setUpEmojiView(using: emoji, ofSize: 48, isCentered: true)
    }

    init(messageAtCenter message: String) {
        super.init(frame: .zero)

        self.setUpMessageView(using: message, isCentered: true)
    }


    private func setUpEmojiView(using emoji: String?, ofSize size: CGFloat = 64, isCentered: Bool = false) {
        self.emoji.text = emoji
        self.emoji.font = .systemFont(ofSize: size)
        self.emoji.textAlignment = .center

        self.addSubview(self.emoji)

        self.emoji.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.emoji.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.emoji.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: isCentered ? 0 : -15)
        ])
    }

    private func setUpMessageView(using message: String?, isCentered: Bool = false) {
        self.message.text = message
        self.message.font = .systemFont(ofSize: 16)
        self.message.textColor = .gray
        self.message.textAlignment = .center
        self.message.numberOfLines = 0

        self.addSubview(self.message)

        self.message.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            isCentered ? self.message.centerYAnchor.constraint(equalTo: self.centerYAnchor) : self.message.topAnchor.constraint(equalTo: self.emoji.bottomAnchor, constant: 10),
            self.message.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.message.widthAnchor.constraint(equalToConstant: 250)
        ])
    }

}
