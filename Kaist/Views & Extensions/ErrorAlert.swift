//
//  ErrorAlert.swift
//  Kaist
//
//  Created by Airat K on 27/3/2023.
//  Copyright © 2023 Airat K. All rights reserved.
//

import UIKit


class ErrorAlert {

    class func show(_ viewController: UIViewController, errorTitle: String, errorMessage: String?, _ completionHandler: ((UIAlertAction) -> Void)? = nil) {
        let errorAlertController: UIAlertController = UIAlertController(title: errorTitle, message: errorMessage ?? "Что-то пошло не так.", preferredStyle: .alert)

        errorAlertController.addAction(UIAlertAction(title: "Окей", style: .default, handler: completionHandler))

        viewController.present(errorAlertController, animated: true)
    }

}
