//
//  PasswordViewModel.swift
//  FileManager
//
//  Created by Дина Шварова on 28.03.2023.
//

import UIKit
import KeychainSwift

enum PasswordError: Error {
    case passwordCouldntBeSave
    case passwordDoesntExist
}

protocol PasswordViewModelProtocol {
    var updateView: ((_ state: PasswordViewState) -> ())? { get set }
    
    func checkPasswordExist()
    func checkPassword(_ password: String)
    func save(_ password: String)
}

final class PasswordViewModel: PasswordViewModelProtocol {
    var navigationController: UINavigationController?
    var updateView: ((_ state: PasswordViewState) -> ())?
    var isChangePassword = false
    
    private let keychain = KeychainSwift()
    private let key = "id"
    private var password = ""
    
    func checkPassword(_ password: String) {
        guard self.password == password else {
            updateView?(.passwordIncorrect)
            return
        }
        goToFileScreen()
    }
    
    func checkPasswordExist() {
        guard !isChangePassword else {
            updateView?(.passwordDoesntExist)
            return
        }
        
        do {
            try getPassword()
            updateView?(.passwordExists)
        }
        catch {
            updateView?(.passwordDoesntExist)
        }
    }
    
    func save(_ password: String) {
        guard keychain.set(password, forKey: key) else {
            return
        }
        goToFileScreen()
    }
    
    private func goToFileScreen() {
        if isChangePassword {
            navigationController?.dismiss(animated: true)
            return
        }
        let vc = setupTabBar()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getPassword() throws {
        guard let password = keychain.get(key) else {
            throw PasswordError.passwordDoesntExist
        }
        self.password = password
    }
    
    private func setupTabBar() -> UIViewController {
        let documentsVC = DocumentsViewController()
        let settingsVC = SettingsViewController()
        
        let documentsNC = UINavigationController(rootViewController: documentsVC)
        let settingsNC = UINavigationController(rootViewController: settingsVC)
        
        let tabbar = UITabBarController()
        tabbar.viewControllers = [documentsNC, settingsNC]
        
        let item1 = UITabBarItem(title: "Files", image: UIImage(systemName: "folder"), tag: 0)
        let item2 = UITabBarItem(title: "Settings", image:  UIImage(systemName: "gear"), tag: 1)
        
        let fileManager = FileManagerService()
        documentsVC.fileManager = fileManager
        settingsVC.delegate = fileManager
        
        documentsNC.tabBarItem = item1
        settingsNC.tabBarItem = item2
        
        UITabBar.appearance().tintColor = .gray
        UITabBar.appearance().backgroundColor = .white
        
        return tabbar
    }
}
