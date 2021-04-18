//
//  TabbarViewController.swift
//  FileManager
//
//  Created by Pavel Yurkov on 17.04.2021.
//

import UIKit

class TabbarViewController: UITabBarController {
    
    private lazy var fileManagerViewController: UINavigationController = {
        let nc = UINavigationController(rootViewController: FileManagerViewController())
        nc.title = "Файлы"
        nc.tabBarItem.image = UIImage(systemName: "filemenu.and.selection")
        return nc
    }()
    
    private lazy var settingsViewController: UINavigationController = {
        let nc = UINavigationController(rootViewController: SettingsViewController())
        nc.title = "Настройки"
        nc.tabBarItem.image = UIImage(systemName: "gearshape.fill")
        return nc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        
        let tabBarViewControllers = [fileManagerViewController, settingsViewController]
        setViewControllers(tabBarViewControllers, animated: false)
    }

}
