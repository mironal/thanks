import Foundation
import Result
import ThanksKit

func collect(opt: CliOption) throws -> [License] {
    let podTargetFilter: (String) -> Bool = {
        if opt.excludePodTargets.count > 0 {
            return { path in
                opt.excludePodTargets.first(where: { p in p.contains("-\(path)-") }) == nil
            }
        }
        return { _ in true }
    }()

    let libraryFilter: (License) -> Bool = {
        if opt.excludeLibraries.count > 0 {
            return { l in
                opt.excludeLibraries.first(where: { ex in ex.uppercased() == l.projectName.uppercased() }) == nil
            }
        }
        return { _ in true }
    }()

    let carthage = try find(opt.rootDir, regex: "^Cartfile$").first.map { cartfile in
        try carthageLicenses(from: cartfile, inDirecoty: opt.rootDir)
    }?.filter(libraryFilter) ?? []

    let cocoapod: [License] = try find(opt.rootDir, regex: "Pods-.+-acknowledgements.markdown$")
        .filter(podTargetFilter)
        .flatMap(cocoaPodsLicenses(from:))
        .filter(libraryFilter)

    if  carthage.count == 0 {
        Console.warn("There are no carthage dependencies.")
    }

    if cocoapod.count == 0 {
        Console.warn("There are no cocoapod dependencies.")
    }

    return carthage + cocoapod
}

func output(_ licenses: [License], opt: CliOption) {
    if opt.summary {
        licenses.forEach { l in
            Console.info("\(l.projectName) in \(l.provider)")
        }
        return
    }

    licenses.forEach { l in

        Console.info("## \(l.projectName)")
        Console.info("")
        Console.info(l.body)
        Console.info("")
    }
}

let result = Result(try CliOption(arguments: Array(CommandLine.arguments.dropFirst())))
    .tryMap {
        (ls: try collect(opt: $0), opt: $0)
    }.map { rs in
        output(rs.ls, opt: rs.opt)
    }

if let error = result.error {
    Console.error(error)
    exit(1)
}
