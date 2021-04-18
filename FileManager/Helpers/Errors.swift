//
//  Errors.swift
//  FileManager
//
//  Created by Pavel Yurkov on 18.04.2021.
//

import UIKit

enum ApiError: Error {
    case passConfirmationError
    case wrongPassword
    case other
}

func handleApiError(error: ApiError, vc: UIViewController) {
    switch error {
    
    case .passConfirmationError:
        Alert.showAlertError(title: "Oops!", message: "Пароли не совпадают", on: vc)
    case .wrongPassword:
        Alert.showAlertError(title: "Oops!", message: "Неверный пароль", on: vc)
    case .other:
        Alert.showAlertError(title: "Oops!", message: "Произошла неизвестная ошибка", on: vc)
    }
    
}
