//
//  ScheduleScreen.swift
//  kaist
//
//  Created by Airat K on 28/6/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class ScheduleScreen: UIViewController {
    
    var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpNavigationItem()
    }
    
    private func setUpView() {
        self.view.backgroundColor = .white
    }
    
    private func setUpNavigationItem() {
        self.navigationItem.titleView = getSegmentedControl(withItems: [ "чётная", "нечётная" ])
    }
    
    private func getSegmentedControl(withItems items: [String]) -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: items)
        
        segmentedControl.selectedSegmentIndex = isCurrentWeekEven() ? 0 : 1
        
        return segmentedControl
    }

}
