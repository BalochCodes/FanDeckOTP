import XCTest
import SwiftUI
@testable import FanDeckOTP

final class FanDeckOTPTests: XCTestCase {
    func testControllerInitializationAndClamping() {
        let controller = FanDeckOTPController(length: 6, initialText: "123456789")
        XCTAssertEqual(controller.length, 6)
        XCTAssertEqual(controller.text, "123456")
        XCTAssertTrue(controller.isComplete)
    }

    func testControllerIncompleteAndCompletion() {
        let controller = FanDeckOTPController(length: 4)
        XCTAssertFalse(controller.isComplete)
        XCTAssertEqual(controller.text, "")

        controller.setCode("987")
        XCTAssertFalse(controller.isComplete)
        XCTAssertEqual(controller.text, "987")

        controller.setCode("9876")
        XCTAssertTrue(controller.isComplete)
        XCTAssertEqual(controller.text, "9876")
    }

    func testControllerClear() {
        let controller = FanDeckOTPController(length: 6, initialText: "1234")
        XCTAssertEqual(controller.text, "1234")
        
        controller.clear()
        XCTAssertEqual(controller.text, "")
        XCTAssertFalse(controller.isComplete)
    }

    func testControllerErrorTrigger() {
        let controller = FanDeckOTPController(length: 4)
        XCTAssertEqual(controller.errorTrigger, 0)

        controller.triggerError()
        XCTAssertEqual(controller.errorTrigger, 1)

        controller.triggerError()
        XCTAssertEqual(controller.errorTrigger, 2)
    }

    func testThemeDefaults() {
        let theme = FanDeckOTPTheme()
        XCTAssertEqual(theme.boxWidth, 48)
        XCTAssertEqual(theme.boxHeight, 58)
        XCTAssertEqual(theme.boxCornerRadius, 12)
        XCTAssertEqual(theme.boxSpacing, 10)
        XCTAssertTrue(theme.enableRotatingBorder)
        XCTAssertTrue(theme.enableHaptics)
    }

    func testCustomThemeOverrides() {
        let theme = FanDeckOTPTheme(
            boxWidth: 54,
            boxHeight: 64,
            boxCornerRadius: 16,
            boxSpacing: 14,
            enableRotatingBorder: false,
            enableHaptics: false
        )
        XCTAssertEqual(theme.boxWidth, 54)
        XCTAssertEqual(theme.boxHeight, 64)
        XCTAssertEqual(theme.boxCornerRadius, 16)
        XCTAssertEqual(theme.boxSpacing, 14)
        XCTAssertFalse(theme.enableRotatingBorder)
        XCTAssertFalse(theme.enableHaptics)
    }

    func testCardBorderLoaderInstantiation() {
        let loader = CardBorderLoader(width: 40, height: 50)
        XCTAssertEqual(loader.width, 40)
        XCTAssertEqual(loader.height, 50)
    }
}
