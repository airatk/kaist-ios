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

        let currentDate = CalendarService.date()
        let dateTitle = "\(currentDate.day) \(currentDate.month)"

        self.viewControllers = [
            self.getTab(for: StudentScheduleController(), withTitle: dateTitle, withImageNamed: CalendarService.imageNameWeekday),
            self.getTab(for: MapController(), withTitle: "Карта", withImageNamed: "Map"),
            self.getTab(for: SettingsController(), withTitle: "Настройки", withImageNamed: "Settings")
        ]
    }


    private func getTab(for screen: UIViewController, withTitle title: String, withImageNamed imageName: String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: screen)

        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)

        return navigationController
    }

}
