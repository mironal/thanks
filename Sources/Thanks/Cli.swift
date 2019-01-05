//
//  Cli.swift
//  Basic
//
//  Created by mba0 on 2019/01/05.
//

import Utility

struct CliOption {
    var rootDir: String = "."
    var summary: Bool = false
    var excludePodTargets: [String] = []
    var excludeLibraries: [String] = []

    var verbose: Bool = false
}

private func bind(_ binder: ArgumentBinder<CliOption>, parser: ArgumentParser) {
    binder.bind(positional: parser.add(positional: "path", kind: String.self,
                                       usage: "The project root directory"),
                to: { $0.rootDir = $1 })

    binder.bind(
        option: parser.add(option: "--exclude", shortName: "-x", kind: [String].self,
                           usage: "List of libraries to ignore"),
        to: { $0.excludeLibraries = $1 }
    )

    binder.bind(option: parser.add(option: "--excludePodTarget", shortName: "-xp", kind: [String].self,
                                   usage: "List of Cocoapod target to ignore"),
                to: { $0.excludePodTargets = $1 })

    binder.bind(option: parser.add(option: "--summary", kind: Bool.self,
                                   usage: "show only library summary"),
                to: { $0.summary = $1 })

    binder.bind(option: parser.add(option: "-verbose", shortName: "-v", kind: Bool.self, usage: "verbose output"),
                to: { $0.verbose = $1 })
}

extension CliOption {
    public init(arguments: [String]) throws {
        let binder = ArgumentBinder<CliOption>()
        let parser = ArgumentParser(usage: "thanks [options] <path/to/xcode/project/dir>",
                                    overview: "Collect library license files in carthage or cocoapod")

        bind(binder, parser: parser)

        let result = try parser.parse(arguments)
        try binder.fill(parseResult: result, into: &self)
    }
}
