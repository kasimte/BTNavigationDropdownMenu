import XCTest
@testable import Demo

class BTForceUnwrapTests: XCTestCase {

    // MARK: - Category A: keyWindow! in init default parameters

    func testInitWithNilContainerViewDoesNotCrash() {
        // Before fix: calling init with containerView: nil would crash because
        // the default parameter was UIApplication.shared.keyWindow!
        // After fix: nil containerView is resolved safely inside the init body
        let menu = BTNavigationDropdownMenu(
            navigationController: nil,
            containerView: nil,
            title: BTTitle.title("Test"),
            items: ["Item 1", "Item 2"]
        )
        XCTAssertNotNil(menu)
    }

    func testConvenienceInitWithNilContainerViewDoesNotCrash() {
        let menu = BTNavigationDropdownMenu(
            navigationController: nil,
            containerView: nil,
            title: "Test",
            items: ["Item 1", "Item 2"]
        )
        XCTAssertNotNil(menu)
    }

    // MARK: - Category B: navigationController! force-unwraps

    func testLayoutSubviewsWithNilNavigationControllerDoesNotCrash() {
        // Before fix: layoutSubviews() force-unwrapped navigationController
        // After fix: guard-let safely returns when navigationController is nil
        let menu = BTNavigationDropdownMenu(
            navigationController: nil,
            containerView: nil,
            title: BTTitle.title("Test"),
            items: ["Item 1"]
        )
        // This should not crash
        menu.layoutSubviews()
    }

    func testShowWithNilNavigationControllerDoesNotCrash() {
        // Before fix: showMenu() force-unwrapped navigationController
        // After fix: guard-let safely returns
        let menu = BTNavigationDropdownMenu(
            navigationController: nil,
            containerView: nil,
            title: BTTitle.title("Test"),
            items: ["Item 1"]
        )
        menu.show()
    }

    // MARK: - Category C: textLabel! force-unwraps

    func testTableViewCellInitDoesNotCrash() {
        // Before fix: textLabel! force-unwrapped 6 times in init
        // After fix: guard-let used safely
        let config = BTConfiguration()
        let cell = BTTableViewCell(
            style: .default,
            reuseIdentifier: "TestCell",
            configuration: config
        )
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.checkmarkIcon)
    }

    // MARK: - Category D: didSelectItemAtIndexHandler! force-unwrap

    func testSelectRowWithNilHandlerDoesNotCrash() {
        // Before fix: BTTableView.didSelectRow force-unwrapped selectRowAtIndexPathHandler
        // After fix: optional chaining used
        let config = BTConfiguration()
        let tableView = BTTableView(
            frame: CGRect(x: 0, y: 0, width: 320, height: 480),
            items: ["Item 1", "Item 2"],
            title: "Item 1",
            configuration: config
        )
        // Leave selectRowAtIndexPathHandler as nil
        tableView.selectRowAtIndexPathHandler = nil

        let indexPath = IndexPath(row: 0, section: 0)
        // This should not crash
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }

    func testMenuSelectionWithNilDidSelectHandlerDoesNotCrash() {
        // The selectRowAtIndexPathHandler closure in BTNavigationDropdownMenu
        // force-unwraps didSelectItemAtIndexHandler — should use optional chaining
        let menu = BTNavigationDropdownMenu(
            navigationController: nil,
            containerView: nil,
            title: BTTitle.title("Test"),
            items: ["Item 1", "Item 2"]
        )
        // Explicitly leave didSelectItemAtIndexHandler nil
        menu.didSelectItemAtIndexHandler = nil
        // setSelected should not crash even without a handler
        menu.setSelected(index: 0)
    }

    // MARK: - Category E: Bundle resource force-unwraps

    func testConfigurationInitProducesValidDefaults() {
        // Before fix: force-unwrapped bundle URL and image paths
        // After fix: guarded with fallback to empty UIImage
        let config = BTConfiguration()
        XCTAssertNotNil(config.arrowImage)
        XCTAssertNotNil(config.checkMarkImage)
        XCTAssertEqual(config.cellHeight, 50)
        XCTAssertEqual(config.animationDuration, 0.5)
        XCTAssertEqual(config.arrowPadding, 15)
        XCTAssertEqual(config.maskBackgroundOpacity, 0.3)
        XCTAssertEqual(config.shouldKeepSelectedCellColor, false)
        XCTAssertEqual(config.shouldChangeTitleText, true)
    }

    // MARK: - BTWindowHelper

    func testActiveWindowDoesNotCrash() {
        // BTWindowHelper.activeWindow should safely return nil or a window
        // without ever force-unwrapping
        let window = BTWindowHelper.activeWindow
        // In a test host environment this may or may not be nil,
        // but it must never crash
        _ = window
    }
}
