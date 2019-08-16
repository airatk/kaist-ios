//
//  ScoreCell.swift
//  kaist
//
//  Created by Airat K on 16/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class ScoreCell: UITableViewCell {
    
    public static let ID = "ScoreCell"
    
    
    public let title = UILabel()
    public let debts = UILabel()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUpSubviews()
        self.addSubviews()
    }
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        self.contentView.backgroundColor = highlighted ? UIColor.lightBlue.withAlphaComponent(0.1) : .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.contentView.backgroundColor = selected ? UIColor.lightBlue.withAlphaComponent(0.1) : .clear
    }
    
    
    override func prepareForReuse() {
        self.title.text = ""
        self.debts.text = ""
    }

}

extension ScoreCell {
    
    private func setUpSubviews() {
        let largeFont = UIFont.boldSystemFont(ofSize: 16)
        let smallFont = UIFont.systemFont(ofSize: 12)
        
        self.title.font = largeFont
        self.title.numberOfLines = 0
        
        self.debts.font = smallFont
        self.debts.textColor = .gray
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.title)
        self.title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.title.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.title.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.title.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        self.contentView.addSubview(self.debts)
        self.debts.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.debts.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 3.5),
            self.debts.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.debts.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.self.contentView.bottomAnchor.constraint(equalTo: self.debts.bottomAnchor, constant: 12)
        ])
    }
    
}
