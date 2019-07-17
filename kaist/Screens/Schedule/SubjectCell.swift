//
//  SubjectCell.swift
//  kaist
//
//  Created by Airat K on 17/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit

class SubjectCell: UITableViewCell {

    public let title: UILabel = {
        let title = UILabel()
        
        title.font = .boldSystemFont(ofSize: 16)
        
        return title
    }()
    public let type: UILabel = {
        let type = UILabel()
        
        type.font = .systemFont(ofSize: 12)
        type.textColor = .gray
        
        return type
    }()
    public let lecturerName: UILabel = {
        let lecturerName = UILabel()
        
        return lecturerName
    }()
    public let department: UILabel = {
        let department = UILabel()
        
        return department
    }()
    public let time: UILabel = {
        let time = UILabel()
        
        return time
    }()
    public let place: UILabel = {
        let place = UILabel()
        
        return place
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }

}
