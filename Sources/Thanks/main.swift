import Foundation
import Result
import ThanksKit

extension Array {
    func uniq<ValueType: Hashable>(keyPath: KeyPath<Element, ValueType>) -> [Element] {
        var memo = Set<ValueType>()
        return filter { elem in

            let value = elem[keyPath: keyPath]
            if memo.contains(value) {
                return false
            }

            memo.insert(value)
            return true
        }
    }
}

protocol Filtee {
    var name: String { get }
}

extension String: Filtee {
    var name: String { return self }
}

extension License: Filtee {
    var name: String { return projectName }
}

func collect(opt: CliOption) throws -> [License] {
    let podTargetFilter: (String) -> Bool = {
        if opt.excludePodTargets.count > 0 {
            return { testee in
                opt.excludePodTargets.first(where: { p in testee.contains("-\(p)-") }) == nil
            }
        }
        return { _ in true }
    }()

    let libraryFilter: (Filtee) -> Bool = {
        if opt.excludeLibraries.count > 0 {
            return { l in
                opt.excludeLibraries.first(where: { ex in ex.uppercased() == l.name.uppercased() }) == nil
            }
        }
        return { _ in true }
    }()

    let cartfilePath = find(opt.rootDir, regex: "^Cartfile$").first

    if cartfilePath == nil {
        Console.warn("Cartfile not found in \(opt.rootDir).")
    }

    let carthage = opt.excludeCarthage ? [] : try cartfilePath.map { try String(contentsOfFile: $0) }
        .flatMap({ cartfile in
            splitCarthageDependencies(cartfile: cartfile)
        })?
        .filter(libraryFilter)
        .map {
            try resolveCarthageLicense(from: $0, in: opt.rootDir)
        } ?? []

    if cartfilePath != nil, !opt.excludeCarthage, carthage.count == 0 {
        Console.warn("There are no carthage dependencies.")
    }

    let cocoapodAckFilepaths = opt.excludeCocoaPod ? [] : find(opt.rootDir, regex: "Pods-.+-acknowledgements.markdown$")
        .filter(podTargetFilter)

    let cocoapods: [License] = try cocoapodAckFilepaths.flatMap {
        cocoaPodsLicenses(from: try String(contentsOfFile: $0), in: $0)
    }.filter(libraryFilter).uniq(keyPath: \.projectName)

    if !opt.excludeCocoaPod, cocoapods.count == 0 {
        Console.warn("There are no cocoapods dependencies.")
    }

    return carthage + cocoapods
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
    .map {
        Console.varbose = $0.verbose
        Console.debug($0)
        return $0
    }
    .tryMap {
        (ls: try collect(opt: $0), opt: $0)
    }.map { rs in
        output(rs.ls, opt: rs.opt)
    }

if let error = result.error {
    Console.error(error)
    exit(1)
}
