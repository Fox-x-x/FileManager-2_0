//
//  isDirectory.swift
//  FileManager
//
//  Created by Pavel Yurkov on 09.04.2021.
//

import UIKit

extension URL {
    
    /// проверяет является ли объект, лежащий по указанному URL, папкой
    func isDirectory() -> Bool {
        do {
            let isDir = (try self.resourceValues(forKeys: [.isDirectoryKey])).isDirectory
            if let _ = isDir, isDir == true {
                return true
            }
        } catch {
            print("error checking if a file is a directory")
        }
        
        return false
    }
    
}
