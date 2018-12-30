//
//  UtilsTest.swift
//  ThanksKitTests
//
//  Created by mba0 on 2018/12/30.
//

@testable import ThanksKit
import XCTest

class UtilsTest: XCTestCase {
    func testProjectName() {
        let invalid = projectName(from: "invalid")
        XCTAssertNil(invalid)

        let name0 = projectName(from: "github \"AgileBits/onepassword-extension\" \"add-framework-support\"")
        XCTAssertEqual(name0, "onepassword-extension")

        let name1 = projectName(from: "github 'AgileBits/onepassword-extension' 'add-framework-support'")
        XCTAssertEqual(name1, "onepassword-extension")

        let cartfile = """
        github "AgileBits/onepassword-extension" "add-framework-support"
        github "realm/realm-cocoa" ~> 3.11.0
        github "DaveWoodCom/XCGLogger" ~> 6.1.0
        github "corin8823/Popover" ~> 1.2.2
        github "iosdevzone/IDZSwiftCommonCrypto" ~> 0.10.0
        github "pinterest/PINCache" ~> 2.3
        github "jdg/MBProgressHUD" ~> 1.1.0
        github "kevin0571/STPopup" ~> 1.8.3
        github "victor-pavlychko/SwiftyAppearance" ~> 1.1.0
        github "delba/TextAttributes"
        github "mironal/NowPlayingFormatter" ~> 1.1.0
        github "HeshamMegid/HMSegmentedControl" ~> 1.5.4
        github "BoltsFramework/Bolts-ObjC" ~> 1.9.0
        github "dzenbot/DZNEmptyDataSet" ~> 1.8.1
        github "rs/SDWebImage" ~> 4.3.3
        github "kishikawakatsumi/KeychainAccess" ~> 3.1.2
        github "mattdonnelly/Swifter"
        """

        let paths = cartfile.components(separatedBy: .newlines).compactMap(projectName(from:))

        XCTAssertEqual(paths, [
            "onepassword-extension",
            "realm-cocoa",
            "XCGLogger",
            "Popover",
            "IDZSwiftCommonCrypto",
            "PINCache",
            "MBProgressHUD",
            "STPopup",
            "SwiftyAppearance",
            "TextAttributes",
            "NowPlayingFormatter",
            "HMSegmentedControl",
            "Bolts-ObjC",
            "DZNEmptyDataSet",
            "SDWebImage",
            "KeychainAccess",
            "Swifter",
        ])
    }

    func testFindLicenseFile() {
        let paths = [
            "Carthage/Checkouts/onepassword-extension",
            "Carthage/Checkouts/realm-cocoa",
            "Carthage/Checkouts/XCGLogger",
            "Carthage/Checkouts/Popover",
            "Carthage/Checkouts/IDZSwiftCommonCrypto",
            "Carthage/Checkouts/PINCache",
            "Carthage/Checkouts/MBProgressHUD",
            "Carthage/Checkouts/STPopup",
            "Carthage/Checkouts/SwiftyAppearance",
            "Carthage/Checkouts/TextAttributes",
            "Carthage/Checkouts/NowPlayingFormatter",
            "Carthage/Checkouts/HMSegmentedControl",
            "Carthage/Checkouts/Bolts-ObjC",
            "Carthage/Checkouts/DZNEmptyDataSet",
            "Carthage/Checkouts/SDWebImage",
            "Carthage/Checkouts/KeychainAccess",
            "Carthage/Checkouts/Swifter",
        ]

        let licenseFilepaths = paths.compactMap(findLicenseFileIn)

        XCTAssertEqual(paths.count, licenseFilepaths.count)
        licenseFilepaths.forEach { path in
            XCTAssertTrue(FileManager.default.fileExists(atPath: path), "Not found file \(path)")
        }
    }

    func testCarthageLicenses() throws {
        let cartfile = """
        github "AgileBits/onepassword-extension" "add-framework-support"
        github "realm/realm-cocoa" ~> 3.11.0
        github "DaveWoodCom/XCGLogger" ~> 6.1.0
        github "corin8823/Popover" ~> 1.2.2
        github "iosdevzone/IDZSwiftCommonCrypto" ~> 0.10.0
        github "pinterest/PINCache" ~> 2.3
        github "jdg/MBProgressHUD" ~> 1.1.0
        github "kevin0571/STPopup" ~> 1.8.3
        github "victor-pavlychko/SwiftyAppearance" ~> 1.1.0
        github "delba/TextAttributes"
        github "mironal/NowPlayingFormatter" ~> 1.1.0
        github "HeshamMegid/HMSegmentedControl" ~> 1.5.4
        github "BoltsFramework/Bolts-ObjC" ~> 1.9.0
        github "dzenbot/DZNEmptyDataSet" ~> 1.8.1
        github "rs/SDWebImage" ~> 4.3.3
        github "kishikawakatsumi/KeychainAccess" ~> 3.1.2
        github "mattdonnelly/Swifter"
        """

        let licenses = try carthageLicenses(from: cartfile)
        XCTAssertEqual(cartfile.components(separatedBy: .newlines).count, licenses.count)
    }
}
