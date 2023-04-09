//
//  AppController.swift
//  Kaist
//
//  Created by Airat K on 1/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class AppController: UITabBarController {

    var statusBarBlur: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))


    override func viewDidLoad() {
        super.viewDidLoad()

        self.statusBarBlur.frame = UIApplication.shared.statusBarFrame
        self.statusBarBlur.isHidden = true

        self.view.addSubview(self.statusBarBlur)

        let currentDate: DateData = CalendarService.getDate()
        let dateTitle: String = "\(currentDate.day) \(currentDate.localizedMonth)"

        self.viewControllers = [
            self.makeTab(for: StudentClassesScheduleController(), usingTitle: dateTitle, usingImageNamed: CalendarService.currentWeekdayImageName),
            self.makeTab(for: UniversityBuildingsController(), usingTitle: "Карта", usingImageNamed: "Map"),
            self.makeTab(for: SettingsController(), usingTitle: "Настройки", usingImageNamed: "Settings")
        ]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(self.welcomeUser), name: .welcomeUser, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard StudentApiService.client.isSignedIn else {
            NotificationCenter.default.post(name: .welcomeUser, object: nil)
            return
        }

        NotificationCenter.default.post(name: .refreshSchedule, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: .welcomeUser, object: nil)
    }

}

extension AppController {

    @objc
    private func welcomeUser() {
        self.present(WelcomeScreenController(), animated: true) {
            self.selectedIndex = 0
        }
    }

}

extension AppController {

    private func makeTab(for screen: UIViewController, usingTitle title: String, usingImageNamed imageName: String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: screen)

        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: nil)

        return navigationController
    }

}
