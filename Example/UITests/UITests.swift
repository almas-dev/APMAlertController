//
//  UITests.swift
//  UITests
//
//  Created by Alexey Korolev on 25.01.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest

class UITests: XCTestCase {

    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMakeScreenshotsPortrait() {
        makeScreenShots(.Portrait, orientationString: "Portrait")
    }

    func testMakeScreenshotsLandscapeLeft() {
        makeScreenShots(.LandscapeLeft, orientationString: "LandscapeLeft")
    }

    private func makeScreenShots(orientation: UIDeviceOrientation, orientationString: String) {
        let app = XCUIApplication()
        XCUIDevice.sharedDevice().orientation = orientation
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Alert Text Title"].tap()
        snapshot("AlertTextTitle" + orientationString)
        app.buttons["Cancel"].tap()
        tablesQuery.staticTexts["Alert Text Title Colored Buttons"].tap()
        snapshot("AlertTextTitleColoredButtons" + orientationString)
        app.buttons["Cancel"].tap()
        tablesQuery.staticTexts["Alert Icon Title"].tap()
        snapshot("AlertIconTitle" + orientationString)
        app.buttons["Cancel"].tap()
    }

}
