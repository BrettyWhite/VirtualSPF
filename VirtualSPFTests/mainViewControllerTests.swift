//
//  MainViewControllerTests.swift
//  MainViewControllerTests
//
//  Created by MiaKitty on 5/27/17.
//  Copyright © 2017 Brett Mcisaac. All rights reserved.
//

import Nimble
import Quick
import XCTest

@testable import VirtualSPF

class MainViewControllerTests: XCTestCase {

    var mainViewController: ViewController! = nil

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mainViewController = ViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mainViewController = nil
        super.tearDown()
    }

}
