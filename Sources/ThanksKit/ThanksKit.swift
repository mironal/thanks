import Foundation

public func carthageLicenses(from cartfilePath: String, inDirecoty directory: String = FileManager.default.currentDirectoryPath) throws -> [License] {
    /*
     1. parse cartfile
     2. resolve license file
     3. build License struct array
     */

    let cwd = URL(fileURLWithPath: directory, isDirectory: true)

    return try String(contentsOfFile: cartfilePath).components(separatedBy: .newlines)
        .compactMap { line in

            guard let name = projectName(from: line),
                let url = Optional.some(cwd.appendingPathComponent(carthageCheckoutPathTemplate.appendingPathComponent(name))),
                let path = findLicenseFileIn(carthageCheckout: url.path) else {
                return nil
            }

            let content = try String(contentsOfFile: path)

            return License(projectName: name, body: content, provider: .carthage)
        }
}

public func cocoaPodsLicenses(from ackFilePath: String) throws -> [License] {
    return try String(contentsOfFile: ackFilePath).components(separatedBy: .newlines)
        .reduce([String]()) { rs, line in // remove header and footer
            var rs = rs

            if rs.count == 0, line.hasPrefix("## ") {
                rs.append(line)
            } else if let last = rs.last, !last.contains(lastMark) {
                rs.append(line)
            }

            return rs
        }.dropLast() // remove lastMark
        .reduce([(name: String, contents: [String])]()) { rs, line in // split each projects

            var rs = rs

            if line.hasPrefix("## ") {
                // remove markdown header
                rs.append((name: line.replacingOccurrences(of: "## ", with: ""), contents: []))
            } else {
                let index = rs.index(before: rs.endIndex)
                rs[index].contents.append(line)
            }

            return rs
        }.map { elem in
            License(projectName: elem.name, body: elem.contents.joined(), provider: .cocoaPods(filename: ackFilePath))
        }
}
