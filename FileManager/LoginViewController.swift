//
//  LoginViewController.swift
//  FileManager
//
//  Created by Pavel Yurkov on 11.04.2021.
//

import UIKit
import SnapKit
import KeychainAccess

class LoginViewController: UIViewController {
    
    private lazy var bundleId = "com.YPS.FileManager"
    private lazy var keychain = Keychain(service: bundleId)
    private lazy var isPassExists: Bool = false
    private lazy var tmpPass: String = ""
    
    private var isInChangePassMode: Bool
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .black
        textField.isSecureTextEntry = true
        textField.placeholder = "Пароль 🔒"
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel").alpha(0.8), for: .highlighted)
        button.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel").alpha(0.8), for: .selected)
        button.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel").alpha(0.5), for: .disabled)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init(isInChangePassMode: Bool) {
        self.isInChangePassMode = isInChangePassMode
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        if let pass = keychain["password"] {
            loginButton.setTitle("Введите пароль", for: .normal)
            isPassExists = true
            print("pass = \(pass)")
        } else {
            loginButton.setTitle("Создать пароль", for: .normal)
        }
        
        setupLayout()
    }
    
    @objc private func loginButtonPressed() {
        
        if isInChangePassMode {
            changePassProcedure()
        } else {
            createPassOrSignInProcedure()
        }
        
    }
    
    private func createPassOrSignInProcedure() {
        // если юзер еще не создавал пароль и вводит его в 1 раз
        if !isPassExists && tmpPass.isEmpty {
            if let passFieldText = passwordTextField.text {
                tmpPass = passFieldText
                passwordTextField.text = ""
                loginButton.setTitle("еще разок", for: .normal)
            }
            // юзер вводит пароль второй раз
        } else if !isPassExists && !tmpPass.isEmpty {
            if let passFieldText = passwordTextField.text {
                if passFieldText == tmpPass {
                    keychain["password"] = passFieldText
                    tmpPass = ""
                    let vc = TabbarViewController()
                    UIApplication.shared.windows.first?.rootViewController = vc
                } else {
                    print("ахтунг, пароль не совпадает!")
                    tmpPass = ""
                    passwordTextField.text = ""
                    loginButton.setTitle("Создать пароль", for: .normal)
                    handleApiError(error: ApiError.passConfirmationError, vc: self)
                }
            }
            // пароль уже есть, нужно просто его ввести
        } else if isPassExists {
            if let passFieldText = passwordTextField.text {
                if passFieldText == keychain["password"] {
                    let vc = TabbarViewController()
                    UIApplication.shared.windows.first?.rootViewController = vc
                } else {
                    print("Неправильный пароль!")
                    passwordTextField.text = ""
                    handleApiError(error: ApiError.wrongPassword, vc: self)
                }
            }
        }
    }
    
    private func changePassProcedure() {
        // юзер вводит пароль в 1-ый раз
        if tmpPass.isEmpty {
            if let passFieldText = passwordTextField.text {
                tmpPass = passFieldText
                passwordTextField.text = ""
                loginButton.setTitle("еще разок", for: .normal)
            }
        } else {
            // юзер вводит пароль во 2-ой раз
            if let passFieldText = passwordTextField.text {
                if passFieldText == tmpPass {
                    keychain["password"] = passFieldText
                    print("Пароль изменен")
                    tmpPass = ""
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("ахтунг, пароль не совпадает!")
                    tmpPass = ""
                    passwordTextField.text = ""
                    loginButton.setTitle("Создать пароль", for: .normal)
                    handleApiError(error: ApiError.passConfirmationError, vc: self)
                }
            }
        }
    }
    
    @objc func textChanged(_ textField: UITextField) {
        if let text = textField.text {
            if text.count < 4 || text.count > 4 {
                loginButton.isEnabled = false
            } else {
                loginButton.isEnabled = true
            }
        }
    }
    
    private func setupLayout() {
        
        view.addSubviews(passwordTextField, loginButton)
        
        passwordTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-64)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.height.equalTo(50)
            make.width.equalTo(passwordTextField)
        }
    }

}
