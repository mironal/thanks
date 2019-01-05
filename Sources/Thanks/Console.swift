//
//  Output.swift
//  Rainbow
//
//  Created by mba0 on 2019/01/01.
//

import Darwin
import Foundation
import Rainbow

class _Console {
    var varbose: Bool = false

    func debug(_ msg: Any) {
        if varbose {
            fputs("\(String(describing: msg))\n".blue, stdout)
        }
    }

    func info(_ msg: Any) {
        fputs("\(String(describing: msg))\n", stdout)
    }

    func warn(_ msg: Any) {
        fputs("\(String(describing: msg))\n".yellow, stderr)
    }

    func error(_ msg: Any) {
        fputs("\(String(describing: msg))\n".red, stderr)
    }
}

let Console = _Console()
