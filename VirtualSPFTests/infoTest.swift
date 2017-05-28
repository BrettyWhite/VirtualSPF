//
//  infoTest.swift
//  VirtualSPF
//
//  Created by MiaKitty on 5/28/17.
//  Copyright © 2017 Brett Mcisaac. All rights reserved.
//

import Nimble
import Quick
import XCTest

@testable import VirtualSPF

class InfoTest: XCTestCase {

    var info: Info! = nil

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        info = Info()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        info = nil
        super.tearDown()
    }

    func testVersion() {
        let appVersion = info.appVersion()
        XCTAssertNotNil(appVersion)
    }

}
