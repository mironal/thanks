//
//  Carthage.swift
//  Thanks
//
//  Created by mba0 on 2018/12/30.
//

import Foundation

let carthageCheckoutPathTemplate = "Carthage/Checkouts"

public func splitCarthageDependencies(cartfile: FileContent) -> [DependencyName] {
    return cartfile.components(separatedBy: .newlines).compactMap(projectName(from:))
}

public func resolveCarthageLicense(from dependency: DependencyName, in directory: Path) throws -> License {
    let carthageCheckoutPath = (directory as NSString).appendingPathComponent(carthageCheckoutPathTemplate) as NSString
    let dir = carthageCheckoutPath.appendingPathComponent(dependency)

    guard let path = findLicenseFileIn(carthageCheckout: dir) else {
        throw ThanksKitError.licenseFileNotFound(inDirectory: dir)
    }

    let content = try String(contentsOfFile: path)
    return License(projectName: dependency, body: content, provider: .carthage)
}

func projectName(from cartfileLine: String) -> String? {
    let regex = try! NSRegularExpression(pattern: "^[^ ]+ [\"'][^ /]+/([^ ]+)[\"'].*$", options: [])

    let range = NSRange(location: 0, length: cartfileLine.count)
    if regex.numberOfMatches(in: cartfileLine, options: [], range: range) == 0 {
        return nil
    }

    let match = regex.stringByReplacingMatches(in: cartfileLine,
                                               options: [],
                                               range: range,
                                               withTemplate: "$1")

    return match
}

func findLicenseFileIn(carthageCheckout repoPath: Path) -> Path? {
    guard let enumerator = FileManager.default.enumerator(atPath: repoPath) else {
        return nil
    }

    let paths: [String] = enumerator.compactMap { elem in

        guard let p = elem as? NSString else {
            return nil
        }

        if p.lastPathComponent.uppercased().hasPrefix("LICENSE") {
            return p as String
        }
        return nil
    }

    guard let first = paths.first else {
        return nil
    }

    return (repoPath as NSString).appendingPathComponent(first)
}
