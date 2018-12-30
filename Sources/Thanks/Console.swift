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
