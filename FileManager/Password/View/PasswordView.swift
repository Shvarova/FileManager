//
//  PasswordView.swift
//  FileManager
//
//  Created by Дина Шварова on 28.03.2023.
//

import UIKit

enum ContinueButtonState: String {
    case passwordExists = "Enter the password"
    case passwordDoenstExist = "Create a password"
    case passwordNeedToBeConfirmed = "Confirm the password"
}

final class PasswordView: UIView {
    
    var continueButtonAction: ((_ password: String) -> ())?
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
//        textField.text = "1234"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.3
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 10, width: 10, height: textField.frame.height))
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(continueButtonTouched), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(continueButton)
        stackView.spacing = 24
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContinueButtonState(state: ContinueButtonState, continueButtonAction: @escaping ((_ password: String) -> ())) {
        switch state {
        case .passwordExists:
            textField.text = ""
            continueButton.setTitle(state.rawValue, for: .normal)
            self.continueButtonAction = continueButtonAction
            deactiveButton()
        case .passwordDoenstExist:
            textField.text = ""
            continueButton.setTitle(state.rawValue, for: .normal)
            self.continueButtonAction = continueButtonAction
            deactiveButton()
        case .passwordNeedToBeConfirmed:
            textField.text = ""
            continueButton.setTitle(state.rawValue, for: .normal)
            self.continueButtonAction = continueButtonAction
            deactiveButton()
        }
    }
    
    @objc private func continueButtonTouched() {
        continueButtonAction?(textField.text!)
    }
    
    @objc private func hideKeyboard() {
        endEditing(true)
    }
    
    private func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        addGestureRecognizer(tap)
        
        backgroundColor = .white
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            continueButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func deactiveButton() {
        continueButton.backgroundColor = .lightGray
        continueButton.isEnabled = false
    }
}

extension PasswordView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return false
        }
        let completeString = text + string
        if completeString.count > 3 && !(completeString.count == 4 && string.isEmpty) {
            continueButton.backgroundColor = .systemBlue
            continueButton.isEnabled = true
        } else {
            deactiveButton()
        }
        return true
    }
}

