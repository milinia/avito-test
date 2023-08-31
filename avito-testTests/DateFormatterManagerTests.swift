//
//  DateFormatterManagerTests.swift
//  avito-testTests
//
//  Created by Evelina on 29.08.2023.
//

import XCTest
@testable import avito_test

final class DateFormatterManagerTests: XCTestCase {
    
    private var dateFormatterManager: DateFormatterManagerProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()
        dateFormatterManager = DateFormatterManager()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        dateFormatterManager = nil
    }

    func testValidValue() {
        //given
        let dateString = "2023-08-14"
        let expectedString = "14 августа"
        //when
        let funcResult = dateFormatterManager.formatDate(stringDate: dateString)
        //then
        XCTAssertEqual(funcResult, expectedString)
    }
    
    func testInvalidValue() {
        //given
        let dateString = "1"
        //when
        let funcResult = dateFormatterManager.formatDate(stringDate: dateString)
        //then
        XCTAssertNil(funcResult)
    }
}
