//
//  AppController.swift
//  Kaist
//
//  Created by Airat K on 1/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class AppController: UITabBarController {

    var statusBarBlur: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.statusBarBlur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        self.statusBarBlur.frame = UIApplication.shared.statusBarFrame
        self.statusBarBlur.isHidden = true

        self.view.addSubview(self.statusBarBlur)

        let currentDate: DateData = CalendarService.getDate()
        let dateTitle: String = "\(currentDate.day) \(currentDate.localizedMonth)"

        self.viewControllers = [
            self.makeTab(for: StudentScheduleController(), usingTitle: dateTitle, usingImageNamed: CalendarService.currentWeekdayImageName),
            self.makeTab(for: MapController(), usingTitle: "Карта", usingImageNamed: "Map"),
            self.makeTab(for: SettingsController(), usingTitle: "Настройки", usingImageNamed: "Settings")
        ]
    }

}

extension AppController {

    private func makeTab(for screen: UIViewController, usingTitle title: String, usingImageNamed imageName: String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: screen)

        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)

        return navigationController
    }

}
