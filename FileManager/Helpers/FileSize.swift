//
//  FileSize.swift
//  FileManager
//
//  Created by Pavel Yurkov on 10.04.2021.
//

import Foundation

extension URL {
    
    func fileSize() -> String? {
        
        let size = try? FileManager.default.attributesOfItem(atPath: self.path)[FileAttributeKey.size]
        
        if let fileSize = size as? Int64 {
            return ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file)
        }
        
        return nil
    }
}
