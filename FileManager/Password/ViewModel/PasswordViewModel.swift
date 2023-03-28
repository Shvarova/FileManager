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
        let vc = DocumentsViewController()
        
        let firstVC = UINavigationController(rootViewController: vc)
        let secondVC = UINavigationController(rootViewController: SettingsViewController())
        
        let tabbar = UITabBarController()
        
        tabbar.viewControllers = [firstVC, secondVC]
        
        let item1 = UITabBarItem(title: "Files", image: UIImage(systemName: "folder"), tag: 0)
        let item2 = UITabBarItem(title: "Settings", image:  UIImage(systemName: "gear"), tag: 1)
        
        firstVC.tabBarItem = item1
        secondVC.tabBarItem = item2
        
        UITabBar.appearance().tintColor = .gray
        UITabBar.appearance().backgroundColor = .white
        
        return tabbar
    }
}
