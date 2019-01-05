//
//  CocoaPodsTest.swift
//  ThanksKitTests
//
//  Created by mba0 on 2018/12/31.
//

import XCTest

@testable import ThanksKit

class CocoaPodsTest: XCTestCase {
    func testCocoaPodsLicenses() throws {
        let ls: [License] = cocoaPodsLicenses(from: """
        hogehoge

        ## One

        hugahuga
        hogehoge

        ## Two

        ああああ

        \(cocoapodAckFileFooterMark)
        """, in: "test file")

        XCTAssertEqual(ls, [
            License(projectName: "One", body: """

            hugahuga
            hogehoge

            """, provider: .cocoaPods(filename: "test file")),
            License(projectName: "Two", body: """

            ああああ

            """, provider: .cocoaPods(filename: "test file")),
        ])
    }
}
