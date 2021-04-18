//
//  Alert.swift
//  FileManager
//
//  Created by Pavel Yurkov on 18.04.2021.
//

import UIKit

class Alert {

    class func showAlertError(title: String, message: String, on viewController: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel) { _ in
            
        }
        alert.addAction(ok)
        viewController.present(alert, animated: true, completion: nil)
    }
}
