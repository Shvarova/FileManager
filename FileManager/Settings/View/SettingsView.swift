//
//  SettingsView.swift
//  FileManager
//
//  Created by Дина Шварова on 28.03.2023.
//

import UIKit

final class SettingsView: UIView {
    var switchAction: ((_ needSorted: Bool) -> ())?

    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sortSwitch: UISwitch = {
        let sortSwitch = UISwitch()
        sortSwitch.backgroundColor = .white
        sortSwitch.addTarget(self, action: #selector(sortSwitched), for: .allEditingEvents)
        sortSwitch.thumbTintColor = .black
        sortSwitch.layer.cornerRadius = 16
        sortSwitch.layer.masksToBounds = true
        sortSwitch.translatesAutoresizingMaskIntoConstraints = false
        return sortSwitch
    }()
    
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change password", for: .normal)
        button.backgroundColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func sortSwitched() {
        switchAction?(sortSwitch.isOn)
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(sortLabel)
        addSubview(sortSwitch)
        addSubview(changePasswordButton)
        
        NSLayoutConstraint.activate([
            sortLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            sortLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        
            sortSwitch.centerYAnchor.constraint(equalTo: sortLabel.centerYAnchor),
            sortSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            changePasswordButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            changePasswordButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            changePasswordButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}


