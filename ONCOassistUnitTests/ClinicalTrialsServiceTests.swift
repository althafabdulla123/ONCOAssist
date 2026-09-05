//
//  ClinicalTrialsServiceTests.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import XCTest
@testable import ONCOassist

@MainActor
final class ClinicalTrialsServiceTests: XCTestCase {

    func testDecodeSampleTrialsJSON() throws {

        let url = Bundle(for: type(of: self)).url(
            forResource: "sample_trials",
            withExtension: "json"
        )

        XCTAssertNotNil(url)

        let data = try Data(contentsOf: url!)

        let result = try JSONDecoder().decode(
            TrialsResponse.self,
            from: data
        )

        XCTAssertEqual(result.studies.count, 1)

        let study = result.studies[0]
        let section = study.protocolSection

        XCTAssertEqual(
            section.identificationModule?.nctId,
            "NCT12345678"
        )

        XCTAssertEqual(
            section.identificationModule?.briefTitle,
            "A Study of Treatment for Lung Cancer"
        )

        XCTAssertEqual(
            section.statusModule?.overallStatus,
            "RECRUITING"
        )

        XCTAssertEqual(
            section.designModule?.phases?.first,
            "PHASE2"
        )

        XCTAssertEqual(
            section.sponsorCollaboratorsModule?.leadSponsor?.name,
            "Example Cancer Institute"
        )
    }
}
