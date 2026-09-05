//
//  MASCCViewModelTests.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//


import XCTest
@testable import ONCOassist

final class MASCCViewModelTests: XCTestCase {

    func testAllMaximumScores26() {
        let viewModel = MASCCViewModel()
        viewModel.selectedOptions = [0, 0, 0, 0, 0, 0, 0]
        viewModel.calculateScore()
        XCTAssertEqual(viewModel.score, 26)
        XCTAssertTrue(viewModel.showResult)
        let riskLevel = (viewModel.score ?? 0) < 21 ? "HIGH RISK" : "LOW RISK"
        XCTAssertEqual(riskLevel, "LOW RISK")
    }

    func testKnownHighRiskScore16() {
        let viewModel = MASCCViewModel()
        viewModel.selectedOptions = [0, 1, 0, 0, 0, 1, 1]
        viewModel.calculateScore()
        XCTAssertEqual(viewModel.score, 16)
        XCTAssertTrue(viewModel.showResult)
    }
}
