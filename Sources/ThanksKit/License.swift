//
//  License.swift
//  Thanks
//
//  Created by mba0 on 2018/12/30.
//

import Foundation

public enum LicenseProvider {
    case cocoaPods(filename: String)
    case carthage
    case other
}

extension LicenseProvider: Equatable {}

public struct License {
    public let projectName: String
    public let body: String
    public let provider: LicenseProvider
}

extension License: Equatable {
    public static func == (lhs: License, rhs: License) -> Bool {
        return lhs.projectName == rhs.projectName && lhs.provider == rhs.provider && lhs.body == rhs.body
    }
}
