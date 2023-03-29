//
//  PasswordFactory.swift
//  FileManager
//
//  Created by Дина Шварова on 29.03.2023.
//

import UIKit

enum PasswordFactory {
    static func getViewController(_ isChangePassword: Bool = false) -> UINavigationController {
        let vc = PasswordViewController()
        let nc = UINavigationController(rootViewController: vc)
        nc.isNavigationBarHidden = true
        let viewModel = PasswordViewModel()
        viewModel.isChangePassword = isChangePassword
        viewModel.navigationController = nc
        vc.setViewModel(viewModel: viewModel)
        return nc
    }
}
