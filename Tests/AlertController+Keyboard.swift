//
// Created by Alexey Korolev on 23.10.2017.
//

import Foundation
import XCTest
@testable import APMAlertController

class APMAlertControllerTest: XCTestCase {
    var alert: APMAlertController!
    var notificationCenterMock: NotificationCenterMock!

    override func setUp() {
        alert = APMAlertController()
        notificationCenterMock = NotificationCenterMock()
        alert.notificationCenter = notificationCenterMock
    }

    override func tearDown() {
        alert = nil
        notificationCenterMock = nil
    }

    func testSubscribingForKeyboardWillShowNotification() {
        alert.beginAppearanceTransition(true, animated: false)
        XCTAssertEqual(notificationCenterMock.isSubscribedForWillShow, true)
    }

    func testSubscribingForKeyboardDidHideNotification() {
        alert.beginAppearanceTransition(true, animated: false)
        XCTAssertEqual(notificationCenterMock.isSubscribedForDidHide, true)
    }

    func testUnsubscribingForKeyboardWillShowNotification() {
        alert = nil
        XCTAssertEqual(notificationCenterMock.isUnsubscribedForWillShow, true)
    }

    func testUnsubscribingForKeyboardDidHideNotification() {
        alert = nil
        XCTAssertEqual(notificationCenterMock.isUnsubscribedForDidHide, true)
    }
}

class NotificationCenterMock: NotificationCenter {

    var isSubscribedForWillShow: Bool = false
    var isSubscribedForDidHide: Bool = false
    var isUnsubscribedForWillShow: Bool = false
    var isUnsubscribedForDidHide: Bool = false

    override func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?) {
        if case UIResponder.keyboardWillShowNotification = aName! {
            isSubscribedForWillShow = true
        } else if case UIResponder.keyboardDidHideNotification = aName! {
            isSubscribedForDidHide = true
        }
    }

    override func removeObserver(_ observer: Any, name aName: NSNotification.Name?, object anObject: Any?) {
        if case UIResponder.keyboardWillShowNotification = aName! {
            isUnsubscribedForWillShow = true
        } else if case UIResponder.keyboardDidHideNotification = aName! {
            isUnsubscribedForDidHide = true
        }
    }
}
