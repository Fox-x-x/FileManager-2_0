//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Pavel Yurkov on 13.04.2021.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    private var defaults = UserDefaults.standard
    
    private lazy var sortContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var sizeContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.text = "Сортировка А -> Я"
        return label
    }()
    
    private lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.text = "Показывать размер файла"
        return label
    }()
    
    private lazy var sortSwitchControl: UISwitch = {
        let SwitchControl = UISwitch()
        SwitchControl.addTarget(self, action: #selector(sortSwitchControlTapped), for: .touchUpInside)
        return SwitchControl
    }()
    
    private lazy var sizeSwitchControl: UISwitch = {
        let SwitchControl = UISwitch()
        SwitchControl.addTarget(self, action: #selector(sizeSwitchControlTapped), for: .touchUpInside)
        return SwitchControl
    }()
    
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Поменять пароль", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.clipsToBounds = true
        button.isEnabled = true
        button.addTarget(self, action: #selector(changePassworButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Настройки"
        
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSettings()
    }
    
    @objc private func sortSwitchControlTapped() {
        print("sort SwitchControl tapped")
        let isSorted = sortSwitchControl.isOn
        defaults.setValue(isSorted, forKey: Options.sort.rawValue)
    }
    
    @objc private func sizeSwitchControlTapped() {
        print("size SwitchControl tapped")
        let isFileSizeShown = sizeSwitchControl.isOn
        defaults.setValue(isFileSizeShown, forKey: Options.showFileSize.rawValue)
    }
    
    @objc private func changePassworButtonPressed() {
        print("changePassworButtonPressed tapped")
        navigationController?.present(LoginViewController(isInChangePassMode: true), animated: true, completion: nil)
    }
    
    private func loadSettings() {
        let isSorted = defaults.object(forKey: Options.sort.rawValue) as? Bool ?? true
        sortSwitchControl.isOn = isSorted
        let isFileSizeShown = defaults.object(forKey: Options.showFileSize.rawValue) as? Bool ?? true
        sizeSwitchControl.isOn = isFileSizeShown
    }

}

private extension SettingsViewController {
    
    func setupLayout() {
        
        sortContainerView.backgroundColor = .systemGray6
        sizeContainerView.backgroundColor = .systemGray6
        
        edgesForExtendedLayout = []
        navigationController?.navigationBar.isTranslucent = false
        
        view.addSubviews(sortContainerView)
        sortContainerView.addSubviews(sortLabel, sortSwitchControl)
        
        view.addSubviews(sizeContainerView, changePasswordButton)
        sizeContainerView.addSubviews(sizeLabel, sizeSwitchControl)
        
        sortContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(44)
        }
        
        sortLabel.snp.makeConstraints { make in
            make.leading.equalTo(sortContainerView.snp.leading)
            make.centerY.equalTo(sortContainerView.snp.centerY)
        }
        
        sortSwitchControl.snp.makeConstraints { make in
            make.trailing.equalTo(sortContainerView.snp.trailing)
            make.centerY.equalTo(sortContainerView.snp.centerY)
        }
        
        sizeContainerView.snp.makeConstraints { make in
            make.top.equalTo(sortContainerView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(44)
        }
        
        sizeLabel.snp.makeConstraints { make in
            make.leading.equalTo(sizeContainerView.snp.leading)
            make.centerY.equalTo(sizeContainerView.snp.centerY)
        }
        
        sizeSwitchControl.snp.makeConstraints { make in
            make.trailing.equalTo(sizeContainerView.snp.trailing)
            make.centerY.equalTo(sizeContainerView.snp.centerY)
        }
        
        changePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(sizeContainerView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(50)
        }
        
    }
    
}
