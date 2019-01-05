import Foundation

public typealias DependencyName = String
public typealias FileContent = String
public typealias Path = String

public enum ThanksKitError: Swift.Error {
    case licenseFileNotFound(inDirectory: Path)
}

extension ThanksKitError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .licenseFileNotFound(
            inDrectory
        ):
            return "License file not found in \(inDrectory)."
        }
    }
}
