//
//  MapScreen.swift
//  kaist
//
//  Created by Airat K on 2/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class MapScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
    }
    
    
    private func setUpNavigationBar() {
        self.navigationItem.title = "Карта"
    }

}
