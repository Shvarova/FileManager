//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Дина Шварова on 28.03.2023.
//

import UIKit

protocol FileManagerDelegate {
    func sortFiles(_ needSorting: Bool)
}

class SettingsViewController: UIViewController {
    var delegate: FileManagerDelegate?
    private let mainView = SettingsView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.switchAction = delegate?.sortFiles(_:)
        mainView.changePasswordAction = {
            let nc = PasswordFactory.getViewController(true)
            self.present(nc, animated: true)
        }
    }
}
