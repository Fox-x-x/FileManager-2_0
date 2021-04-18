//
//  CreateDirAlert.swift
//  FileManager
//
//  Created by Pavel Yurkov on 10.04.2021.
//

import UIKit

extension FileManagerViewController {
    
    func createDirUsingAlert(in currentDir: URL, usingFileManage fileManager: FileManager) {
        
        let alert = UIAlertController(title: "Create new directory", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create", style: .default) { [weak self] action in
            
            guard let vc = self else { return }
            
            if let name = alert.textFields?.first?.text {
                var newDir = currentDir
                newDir.appendPathComponent(name)
                do {
                    try fileManager.createDirectory(at: newDir, withIntermediateDirectories: false, attributes: nil)
                    vc.showFilesFor(dir: currentDir, using: fileManager)
                } catch {
                    print("\(error.localizedDescription)")
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Type in dir name"
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
