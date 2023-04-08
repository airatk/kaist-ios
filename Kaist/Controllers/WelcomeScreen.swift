//
//  WelcomeScreen.swift
//  Kaist
//
//  Created by Airat K on 12/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class WelcomeScreenController: UIViewController {

    private let welcomeView: UIStackView = UIStackView()

    private let headerView: UIStackView = UIStackView()
    private let welcomeLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()

    private let groupNumberView: UIStackView = UIStackView()
    private let groupNumberField: RoundedTextField = RoundedTextField()
    private let checkGroupNumberButton: UIButton = UIButton()
    private let groupNumberHint: UILabel = UILabel()
    private let groupNumberActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.presentationController?.delegate = self

        self.view.backgroundColor = .systemBackground
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
        self.view.addSubview(self.welcomeView)

        self.setUpWelcomeView()
    }

}

extension WelcomeScreenController {

    private func setUpWelcomeView() {
        self.welcomeView.axis = .vertical
        self.welcomeView.spacing = 32

        self.welcomeView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.welcomeView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 24),
            self.welcomeView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.welcomeView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
        ])

        self.welcomeView.addArrangedSubview(self.headerView)
        self.welcomeView.addArrangedSubview(self.groupNumberView)

        self.setUpHeaderView()
        self.setUpGroupNumberView()
    }

    private func setUpHeaderView() {
        self.headerView.axis = .vertical
        self.headerView.spacing = 16

        self.headerView.addArrangedSubview(self.welcomeLabel)
        self.headerView.addArrangedSubview(self.descriptionLabel)

        self.welcomeLabel.text = "Добро пожаловать♥️"
        self.welcomeLabel.numberOfLines = 0
        self.welcomeLabel.font = .boldSystemFont(ofSize: 42)

        self.descriptionLabel.text = "Расписание твоих занятий и занятий преподавателей, местоположения каёвских зданий, чётность учебной недели — всё для тебя в этом приложении, каист!✈️"
        self.descriptionLabel.numberOfLines = 0
    }

    private func setUpGroupNumberView() {
        self.groupNumberView.axis = .vertical
        self.groupNumberView.spacing = 16

        self.groupNumberView.addArrangedSubview(self.makeFormRow(usingField: self.groupNumberField, usingButton: self.checkGroupNumberButton))
        self.groupNumberView.addArrangedSubview(self.groupNumberHint)

        self.groupNumberField.placeholder = "Номер группы"
        self.groupNumberField.keyboardType = .numberPad
        self.groupNumberField.returnKeyType = .send
        self.groupNumberField.delegate = self

        self.groupNumberHint.text = "Введи номер твоей учебной группы (например, 4201)."
        self.groupNumberHint.textColor = .systemGray
        self.groupNumberHint.numberOfLines = 0
        self.groupNumberHint.font = .systemFont(ofSize: 13)

        self.checkGroupNumberButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        self.checkGroupNumberButton.setImage(UIImage(), for: .disabled)
        self.checkGroupNumberButton.backgroundColor = .systemGray
        self.checkGroupNumberButton.tintColor = .systemBackground
        self.checkGroupNumberButton.layer.cornerRadius = 12
        self.checkGroupNumberButton.clipsToBounds = true
        self.checkGroupNumberButton.addTarget(self, action: #selector(self.checkGroupNumber), for: .touchUpInside)
        self.checkGroupNumberButton.addActivityIndicator(self.groupNumberActivityIndicator)

        self.groupNumberActivityIndicator.color = .systemBackground
    }


    private func makeFormRow(usingField textField: UITextField, usingButton button: UIButton) -> UIStackView {
        let formRow: UIStackView = UIStackView(arrangedSubviews: [ textField, button ])

        formRow.axis = .horizontal
        formRow.spacing = 8

        textField.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        let universalSize: CGFloat = 60.0

        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: universalSize),

            button.widthAnchor.constraint(equalToConstant: universalSize),
            button.heightAnchor.constraint(equalToConstant: universalSize),
        ])

        return formRow
    }

}

extension WelcomeScreenController: UIAdaptivePresentationControllerDelegate {

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }

}

extension WelcomeScreenController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.popAnimate {
            self.headerView.hideChangingTransparency()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.popAnimate {
            self.headerView.showChangingTransparency()
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text as? NSString else { return false }

        textField.text = text.replacingCharacters(in: range, with: string).trimmingCharacters(in: .whitespacesAndNewlines)

        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.groupNumberField:
            self.checkGroupNumber()

        default:
            break
        }

        return true
    }


    @objc
    private func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @objc
    private func checkGroupNumber() {
        guard let groupNumber = self.groupNumberField.text, !groupNumber.isEmpty else {
            self.groupNumberField.shake()
            return
        }

        self.dismissKeyboard()
        self.groupNumberActivityIndicator.startAnimating()
        self.checkGroupNumberButton.isEnabled = false

        StudentApiService.client.saveGroup(withNumber: groupNumber) { error in
            defer {
                self.groupNumberActivityIndicator.stopAnimating()
                self.checkGroupNumberButton.isEnabled = true
            }

            if let error = error {
                ErrorAlert.show(self, errorTitle: "Ошибка входа", errorMessage: error.localizedDescription)
            } else {
                self.dismiss(animated: true)
            }
        }
    }

}
