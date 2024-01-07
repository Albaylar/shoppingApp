//
//  eterationCaseStudyTests.swift
//  eterationCaseStudyTests
//
//  Created by Furkan Deniz Albaylar on 4.01.2024.
//

import XCTest
@testable import eterationCaseStudy

final class eterationCaseStudyTests: XCTestCase {

    var viewModel: HomeViewModel!

    override func setUpWithError() throws {
        super.setUp()
        viewModel = HomeViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }

    func testLoadAllCars() throws {
        let expectation = self.expectation(description: "loadAllCars")

        viewModel.loadAllCars {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertFalse(viewModel.cars.isEmpty, "Cars array should not be empty after loading")
    }
}

