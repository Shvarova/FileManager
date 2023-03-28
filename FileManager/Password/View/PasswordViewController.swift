//
//  PasswordViewController.swift
//  FileManager
//
//  Created by Дина Шварова on 28.03.2023.
//

import UIKit

enum PasswordViewState {
    case passwordDoesntExist
    case passwordExists
    case passwordIncorrect
}

final class PasswordViewController: UIViewController {
    private let mainView = PasswordView()
    private var viewModel: PasswordViewModelProtocol?
    
    private var currentPassword = ""
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setViewModel(viewModel: PasswordViewModelProtocol) {
        self.viewModel = viewModel
        loadData()
    }
    
    private func loadData() {
        viewModel?.updateView = updateMainView
        viewModel?.checkPasswordExist()
    }
    
    private func updateMainView(_ state: PasswordViewState) {
        switch state {
        case .passwordExists:
            mainView.setContinueButtonState(state: .passwordExists) { password in
                self.viewModel?.checkPassword(password)
            }
        case .passwordDoesntExist:
            mainView.setContinueButtonState(state: .passwordDoenstExist) { password in
                self.currentPassword = password
                self.mainView.setContinueButtonState(state: .passwordNeedToBeConfirmed) { password in
                    if self.currentPassword == password {
                        self.viewModel?.save(password)
                    } else {
                        self.showErrorAlert(with: "Entered passwords do not match")
                        self.updateMainView(.passwordDoesntExist)
                    }
                }
            }
        case .passwordIncorrect:
            showErrorAlert(with: "Password is incorrect")
        }
    }
    
    private func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
