//
//  explainationViewTests.swift
//  VirtualSPF
//
//  Created by MiaKitty on 5/28/17.
//  Copyright © 2017 Bretty White. All rights reserved.
//

import Nimble
import Quick
import XCTest

@testable import VirtualSPF

class ExplainationViewTests: XCTestCase {

    var explainationView: ExplainationView! = nil

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        explainationView = ExplainationView()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        explainationView = nil
        super.tearDown()
    }

}
