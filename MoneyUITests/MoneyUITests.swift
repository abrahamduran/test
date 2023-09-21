//
//  MoneyUITests.swift
//  MoneyUITests
//
//  Created by Philippe Boudreau on 2023-08-15.
//

import XCTest

final class MoneyUITests: XCTestCase {
    func testInitialState() throws {
        let app = XCUIApplication()
        app.launch()

        // Account Balance
        XCTAssertTrue(app.staticTexts["Account Balance"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["$12,312.01"].exists)

        // Transactions
        XCTAssertTrue(app.collectionViews["TransactionList"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["TransactionRow"].waitForExistence(timeout: 10))
    }
}
