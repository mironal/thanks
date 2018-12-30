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

public struct License {
    public let projectName: String
    public let body: String
    public let provider: LicenseProvider
}
