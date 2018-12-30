//
//  CocoaPodsTest.swift
//  ThanksKitTests
//
//  Created by mba0 on 2018/12/31.
//

import XCTest

@testable import ThanksKit

class CocoaPodsTest: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let path = Bundle(for: type(of: self)).path(forResource: "Pods-TestProject-acknowledgements", ofType: "markdown")

        let markdown = try String(contentsOfFile: path!)

        let ls = try cocoaPodsLicenses(from: markdown)
        XCTAssertTrue(ls.count > 0)
    }
}
