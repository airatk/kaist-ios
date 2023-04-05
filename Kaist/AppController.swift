//
//  AppController.swift
//  Kaist
//
//  Created by Airat K on 1/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class AppController: UITabBarController {

    public var statusBarBlur: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.statusBarBlur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        self.statusBarBlur.frame = UIApplication.shared.statusBarFrame
        self.statusBarBlur.isHidden = true

        self.view.addSubview(self.statusBarBlur)

        let currentDate: DateData = CalendarService.getDate()
        let dateTitle: String = "\(currentDate.day) \(currentDate.localizedMonth)"

        self.viewControllers = [
            self.getTab(for: StudentScheduleController(), withTitle: dateTitle, withImageNamed: CalendarService.currentWeekdayImageName),
            self.getTab(for: MapController(), withTitle: "Карта", withImageNamed: "Map"),
            self.getTab(for: SettingsController(), withTitle: "Настройки", withImageNamed: "Settings")
        ]
    }

}

extension AppController {

    private func getTab(for screen: UIViewController, withTitle title: String, withImageNamed imageName: String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: screen)

        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)

        return navigationController
    }

}
