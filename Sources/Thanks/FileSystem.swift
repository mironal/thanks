//
//  FileSystem.swift
//  Rainbow
//
//  Created by mba0 on 2019/01/01.
//

import Foundation

func find(_ rootDir: String, regex pattern: String) -> [String] {
    guard let enumerator = FileManager.default.enumerator(atPath: rootDir) else {
        return []
    }

    return enumerator.compactMap {
        guard let path = $0 as? String else {
            return nil
        }

        if path.range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil {
            return (rootDir as NSString).appendingPathComponent(path) as String
        }
        return nil
    }
}
