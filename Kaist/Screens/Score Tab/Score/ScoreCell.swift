//
//  ScoreCell.swift
//  kaist
//
//  Created by Airat K on 16/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class ScoreCell: UITableViewCell {
    
    public static let reuseID = "ScoreCell"
    
    
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
    
    public let scoreLine1MaximumScore = UILabel()
    public let scoreLine2MaximumScore = UILabel()
    public let scoreLine3MaximumScore = UILabel()
    public let scoreLine1GainedScore = UILabel()
    public let scoreLine2GainedScore = UILabel()
    public let scoreLine3GainedScore = UILabel()
    
    private let scoreLine1HitMaximum = UIImageView(image: UIImage(named: "HitMaximumScore"))
    private let scoreLine2HitMaximum = UIImageView(image: UIImage(named: "HitMaximumScore"))
    private let scoreLine3HitMaximum = UIImageView(image: UIImage(named: "HitMaximumScore"))
    
    private var iconSize: CGFloat {
        return self.scoreLineHeight*0.6
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUpSubviews()
        self.addSubviews()
        
        self.selectionStyle = .none
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.scoreLine1MaximumScore.text = nil
        self.scoreLine2MaximumScore.text = nil
        self.scoreLine3MaximumScore.text = nil
        self.scoreLine1GainedScore.text = nil
        self.scoreLine2GainedScore.text = nil
        self.scoreLine3GainedScore.text = nil
    }

}

extension ScoreCell {
    
    private func setUpSubviews() {
        let largeFont = UIFont.boldSystemFont(ofSize: 16)
        let middleFont = UIFont.boldSystemFont(ofSize: 12)
        let smallFont = UIFont.systemFont(ofSize: 12)
        
        let scoreLineColor = UIColor.lightBlue.withAlphaComponent(0.85)
        let scoreLineCornerRadius: CGFloat = 6
        
        self.title.font = largeFont
        self.title.numberOfLines = 0
        
        self.debts.font = smallFont
        self.debts.textColor = .gray
        
        self.scoreLine1.backgroundColor = scoreLineColor
        self.scoreLine1.layer.cornerRadius = scoreLineCornerRadius
        self.scoreLine1.clipsToBounds = true
        self.scoreLine2.backgroundColor = scoreLineColor
        self.scoreLine2.layer.cornerRadius = scoreLineCornerRadius
        self.scoreLine2.clipsToBounds = true
        self.scoreLine3.backgroundColor = scoreLineColor
        self.scoreLine3.layer.cornerRadius = scoreLineCornerRadius
        self.scoreLine3.clipsToBounds = true
        
        self.scoreLine1MaximumScore.font = middleFont
        self.scoreLine1MaximumScore.textColor = .white
        self.scoreLine2MaximumScore.font = middleFont
        self.scoreLine2MaximumScore.textColor = .white
        self.scoreLine3MaximumScore.font = middleFont
        self.scoreLine3MaximumScore.textColor = .white
        self.scoreLine1GainedScore.font = middleFont
        self.scoreLine1GainedScore.textColor = .white
        self.scoreLine2GainedScore.font = middleFont
        self.scoreLine2GainedScore.textColor = .white
        self.scoreLine3GainedScore.font = middleFont
        self.scoreLine3GainedScore.textColor = .white
        
        self.scoreLine1HitMaximum.setTintColor(.white)
        self.scoreLine2HitMaximum.setTintColor(.white)
        self.scoreLine3HitMaximum.setTintColor(.white)
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
            self.debts.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 3),
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
        
        self.contentView.addSubview(self.scoreLine1MaximumScore)
        self.contentView.addSubview(self.scoreLine2MaximumScore)
        self.contentView.addSubview(self.scoreLine3MaximumScore)
        self.contentView.addSubview(self.scoreLine1GainedScore)
        self.contentView.addSubview(self.scoreLine2GainedScore)
        self.contentView.addSubview(self.scoreLine3GainedScore)
        self.scoreLine1MaximumScore.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLine2MaximumScore.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLine3MaximumScore.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLine1GainedScore.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLine2GainedScore.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLine3GainedScore.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scoreLine1MaximumScore.centerYAnchor.constraint(equalTo: self.scoreLine1.centerYAnchor),
            self.scoreLine1MaximumScore.leadingAnchor.constraint(equalTo: self.scoreLine1.leadingAnchor, constant: self.scoreLineHorizontalPadding),
            
            self.scoreLine2MaximumScore.centerYAnchor.constraint(equalTo: self.scoreLine2.centerYAnchor),
            self.scoreLine2MaximumScore.leadingAnchor.constraint(equalTo: self.scoreLine2.leadingAnchor, constant: self.scoreLineHorizontalPadding),
            
            self.scoreLine3MaximumScore.centerYAnchor.constraint(equalTo: self.scoreLine3.centerYAnchor),
            self.scoreLine3MaximumScore.leadingAnchor.constraint(equalTo: self.scoreLine3.leadingAnchor, constant: self.scoreLineHorizontalPadding),
            
            self.scoreLine1GainedScore.centerYAnchor.constraint(equalTo: self.scoreLine1.centerYAnchor),
            self.scoreLine1GainedScore.trailingAnchor.constraint(equalTo: self.scoreLine1.trailingAnchor, constant: -self.scoreLineHorizontalPadding),
            
            self.scoreLine2GainedScore.centerYAnchor.constraint(equalTo: self.scoreLine2.centerYAnchor),
            self.scoreLine2GainedScore.trailingAnchor.constraint(equalTo: self.scoreLine2.trailingAnchor, constant: -self.scoreLineHorizontalPadding),
            
            self.scoreLine3GainedScore.centerYAnchor.constraint(equalTo: self.scoreLine3.centerYAnchor),
            self.scoreLine3GainedScore.trailingAnchor.constraint(equalTo: self.scoreLine3.trailingAnchor, constant: -self.scoreLineHorizontalPadding),
        ])
        
        self.contentView.addSubview(self.scoreLine1HitMaximum)
        self.contentView.addSubview(self.scoreLine2HitMaximum)
        self.contentView.addSubview(self.scoreLine3HitMaximum)
        self.scoreLine1HitMaximum.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLine2HitMaximum.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLine3HitMaximum.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scoreLine1HitMaximum.centerXAnchor.constraint(equalTo: self.scoreLine1.centerXAnchor),
            self.scoreLine1HitMaximum.centerYAnchor.constraint(equalTo: self.scoreLine1.centerYAnchor),
            self.scoreLine1HitMaximum.widthAnchor.constraint(equalToConstant: self.iconSize),
            self.scoreLine1HitMaximum.heightAnchor.constraint(equalTo: self.scoreLine1HitMaximum.widthAnchor, multiplier: 1),
            
            self.scoreLine2HitMaximum.centerXAnchor.constraint(equalTo: self.scoreLine2.centerXAnchor),
            self.scoreLine2HitMaximum.centerYAnchor.constraint(equalTo: self.scoreLine2.centerYAnchor),
            self.scoreLine2HitMaximum.widthAnchor.constraint(equalToConstant: self.iconSize),
            self.scoreLine2HitMaximum.heightAnchor.constraint(equalTo: self.scoreLine2HitMaximum.widthAnchor, multiplier: 1),
            
            self.scoreLine3HitMaximum.centerXAnchor.constraint(equalTo: self.scoreLine3.centerXAnchor),
            self.scoreLine3HitMaximum.centerYAnchor.constraint(equalTo: self.scoreLine3.centerYAnchor),
            self.scoreLine3HitMaximum.widthAnchor.constraint(equalToConstant: self.iconSize),
            self.scoreLine3HitMaximum.heightAnchor.constraint(equalTo: self.scoreLine3HitMaximum.widthAnchor, multiplier: 1)
        ])
        
        self.contentView.bottomAnchor.constraint(equalTo: self.scoreLine3.bottomAnchor, constant: 12).isActive = true
    }
    
    
    public func setScoreLine(_ scoreLine: ScoreCell.ScoreLine, gained: String, maximum: String) {
        let multiplier = maximum == "0" ? 0 : CGFloat(Int(gained)!)/CGFloat(Int(maximum)!)
        var width = self.maxScoreLineWidth*multiplier
        
        if width == 0 {
            width = self.zeroScoreLineWidth
        } else if width < self.minScoreLineWidth {
            width = self.minScoreLineWidth
        }
        
        switch scoreLine {
            case .first:
                self.scoreLine1WidthConstraint.constant = width
                self.scoreLine1MaximumScore.text = maximum
                self.scoreLine1GainedScore.text = maximum == "0" ? nil : gained
                self.scoreLine1HitMaximum.isHidden = gained != maximum || maximum == "0"
            case .middle:
                self.scoreLine2WidthConstraint.constant = width
                self.scoreLine2MaximumScore.text = maximum
                self.scoreLine2GainedScore.text = maximum == "0" ? nil : gained
                self.scoreLine2HitMaximum.isHidden = gained != maximum || maximum == "0"
            case .last:
                self.scoreLine3WidthConstraint.constant = width
                self.scoreLine3MaximumScore.text = maximum
                self.scoreLine3GainedScore.text = maximum == "0" ? nil : gained
                self.scoreLine3HitMaximum.isHidden = gained != maximum || maximum == "0"
        }
    }
    
    public enum ScoreLine {
        case first
        case middle
        case last
    }
    
}
