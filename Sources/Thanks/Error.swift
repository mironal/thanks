//
//  Error.swift
//  Basic
//
//  Created by mba0 on 2019/01/05.
//

import Result
import Utility

enum ThanksError: Swift.Error, ErrorConvertible {
    static func error(from error: Error) -> ThanksError {
        return .convertedFromOtherError(error)
    }

    case convertedFromOtherError(_ error: Error)
    case invalidCommandLineArgument(_ error: ArgumentParserError)
}

extension ThanksError: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .invalidCommandLineArgument(e):
            return "invalid command line argument. \(e)"
        case let .convertedFromOtherError(e):
            return "converted from \(e)"
        }
    }
}
