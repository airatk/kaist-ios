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
    
    
    private let scoreLineHeight: CGFloat = 26
    private let scoreLineTopMargin: CGFloat = 4
    private let scoreLineHorizontalMargin: CGFloat = 15
    private let scoreLineHorizontalPadding: CGFloat = 8
    private var maxScoreLineWidth: CGFloat {
        return self.contentView.frame.width - self.scoreLineHorizontalMargin*2
    }
    private var minScoreLineWidth: CGFloat {
        return self.maxScoreLineWidth*0.2
    }
    private let zeroScoreLineWidth: CGFloat = 24
    
    public let title = UILabel()
    public let debts = UILabel()
    
    public let scoreLine1 = UIView()
    public let scoreLine2 = UIView()
    public let scoreLine3 = UIView()
    
    private var scoreLine1WidthConstraint: NSLayoutConstraint!
    private var scoreLine2WidthConstraint: NSLayoutConstraint!
    private var scoreLine3WidthConstraint: NSLayoutConstraint!
    
    public let sertification1Maximum = UILabel()
    public let sertification2Maximum = UILabel()
    public let sertification3Maximum = UILabel()
    public let sertification1Gained = UILabel()
    public let sertification2Gained = UILabel()
    public let sertification3Gained = UILabel()
    
    
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
        self.sertification1Maximum.text = nil
        self.sertification2Maximum.text = nil
        self.sertification3Maximum.text = nil
        self.sertification1Gained.text = nil
        self.sertification2Gained.text = nil
        self.sertification3Gained.text = nil
    }

}

extension ScoreCell {
    
    private func setUpSubviews() {
        let largeFont = UIFont.boldSystemFont(ofSize: 16)
        let middleFont = UIFont.boldSystemFont(ofSize: 12)
        let smallFont = UIFont.systemFont(ofSize: 12)
        
        self.title.font = largeFont
        self.title.numberOfLines = 0
        
        self.debts.font = smallFont
        self.debts.textColor = .gray
        
        self.scoreLine1.backgroundColor = UIColor.lightBlue.withAlphaComponent(0.75)
        self.scoreLine1.layer.cornerRadius = 6
        self.scoreLine1.clipsToBounds = true
        
        self.scoreLine2.backgroundColor = UIColor.lightBlue.withAlphaComponent(0.75)
        self.scoreLine2.layer.cornerRadius = 6
        self.scoreLine2.clipsToBounds = true
        
        self.scoreLine3.backgroundColor = UIColor.lightBlue.withAlphaComponent(0.75)
        self.scoreLine3.layer.cornerRadius = 6
        self.scoreLine3.clipsToBounds = true
        
        self.sertification1Maximum.font = middleFont
        self.sertification1Maximum.textColor = .white
        self.sertification2Maximum.font = middleFont
        self.sertification2Maximum.textColor = .white
        self.sertification3Maximum.font = middleFont
        self.sertification3Maximum.textColor = .white
        self.sertification1Gained.font = middleFont
        self.sertification1Gained.textColor = .white
        self.sertification2Gained.font = middleFont
        self.sertification2Gained.textColor = .white
        self.sertification3Gained.font = middleFont
        self.sertification3Gained.textColor = .white
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
        
        self.contentView.addSubview(self.scoreLine1)
        self.contentView.addSubview(self.scoreLine2)
        self.contentView.addSubview(self.scoreLine3)
        self.scoreLine1.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLine2.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLine3.translatesAutoresizingMaskIntoConstraints = false
        
        self.scoreLine1WidthConstraint = self.scoreLine1.widthAnchor.constraint(equalToConstant: self.minScoreLineWidth)
        self.scoreLine2WidthConstraint = self.scoreLine2.widthAnchor.constraint(equalToConstant: self.minScoreLineWidth)
        self.scoreLine3WidthConstraint = self.scoreLine3.widthAnchor.constraint(equalToConstant: self.minScoreLineWidth)
        
        NSLayoutConstraint.activate([
            self.scoreLine1.topAnchor.constraint(equalTo: self.debts.bottomAnchor, constant: 12),
            self.scoreLine1.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: self.scoreLineHorizontalMargin),
            self.scoreLine1WidthConstraint,
            self.scoreLine1.heightAnchor.constraint(equalToConstant: self.scoreLineHeight),
            
            self.scoreLine2.topAnchor.constraint(equalTo: self.scoreLine1.bottomAnchor, constant: self.scoreLineTopMargin),
            self.scoreLine2.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: self.scoreLineHorizontalMargin),
            self.scoreLine2WidthConstraint,
            self.scoreLine2.heightAnchor.constraint(equalToConstant: self.scoreLineHeight),
            
            self.scoreLine3.topAnchor.constraint(equalTo: self.scoreLine2.bottomAnchor, constant: self.scoreLineTopMargin),
            self.scoreLine3.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: self.scoreLineHorizontalMargin),
            self.scoreLine3WidthConstraint,
            self.scoreLine3.heightAnchor.constraint(equalToConstant: self.scoreLineHeight),
        ])
        
        self.contentView.addSubview(self.sertification1Maximum)
        self.contentView.addSubview(self.sertification2Maximum)
        self.contentView.addSubview(self.sertification3Maximum)
        self.contentView.addSubview(self.sertification1Gained)
        self.contentView.addSubview(self.sertification2Gained)
        self.contentView.addSubview(self.sertification3Gained)
        self.sertification1Maximum.translatesAutoresizingMaskIntoConstraints = false
        self.sertification2Maximum.translatesAutoresizingMaskIntoConstraints = false
        self.sertification3Maximum.translatesAutoresizingMaskIntoConstraints = false
        self.sertification1Gained.translatesAutoresizingMaskIntoConstraints = false
        self.sertification2Gained.translatesAutoresizingMaskIntoConstraints = false
        self.sertification3Gained.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.sertification1Maximum.centerYAnchor.constraint(equalTo: self.scoreLine1.centerYAnchor),
            self.sertification1Maximum.leadingAnchor.constraint(equalTo: self.scoreLine1.leadingAnchor, constant: self.scoreLineHorizontalPadding),
            
            self.sertification2Maximum.centerYAnchor.constraint(equalTo: self.scoreLine2.centerYAnchor),
            self.sertification2Maximum.leadingAnchor.constraint(equalTo: self.scoreLine2.leadingAnchor, constant: self.scoreLineHorizontalPadding),
            
            self.sertification3Maximum.centerYAnchor.constraint(equalTo: self.scoreLine3.centerYAnchor),
            self.sertification3Maximum.leadingAnchor.constraint(equalTo: self.scoreLine3.leadingAnchor, constant: self.scoreLineHorizontalPadding),
            
            self.sertification1Gained.centerYAnchor.constraint(equalTo: self.scoreLine1.centerYAnchor),
            self.sertification1Gained.trailingAnchor.constraint(equalTo: self.scoreLine1.trailingAnchor, constant: -self.scoreLineHorizontalPadding),
            
            self.sertification2Gained.centerYAnchor.constraint(equalTo: self.scoreLine2.centerYAnchor),
            self.sertification2Gained.trailingAnchor.constraint(equalTo: self.scoreLine2.trailingAnchor, constant: -self.scoreLineHorizontalPadding),
            
            self.sertification3Gained.centerYAnchor.constraint(equalTo: self.scoreLine3.centerYAnchor),
            self.sertification3Gained.trailingAnchor.constraint(equalTo: self.scoreLine3.trailingAnchor, constant: -self.scoreLineHorizontalPadding),
        ])
        
        self.contentView.bottomAnchor.constraint(equalTo: self.scoreLine3.bottomAnchor, constant: 12).isActive = true
    }
    
    
    public func setScoreLineWidth(withMultiplier multiplier: CGFloat = 0, scoreLine: ScoreCell.ScoreLine) {
        var width: CGFloat {
            switch multiplier {
                case 0: return self.zeroScoreLineWidth
                case _ where self.maxScoreLineWidth*multiplier < self.minScoreLineWidth: return self.minScoreLineWidth
                
                default: return self.maxScoreLineWidth*multiplier
            }
        }
        
        switch scoreLine {
            case .first: self.scoreLine1WidthConstraint.constant = width
            case .middle: self.scoreLine2WidthConstraint.constant = width
            case .last: self.scoreLine3WidthConstraint.constant = width
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.4, options: .curveEaseOut, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
    public enum ScoreLine {
        case first
        case middle
        case last
    }
    
}
