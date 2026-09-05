//
//  ClinicalTrialModels.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import Foundation

struct TrialsResponse: Codable {
    let studies: [Study]
    let nextPageToken: String?
}

struct Study: Codable {
    let protocolSection: ProtocolSection
}

struct ProtocolSection: Codable {
    let identificationModule: IdentificationModule?
    let statusModule: StatusModule?
    let designModule: DesignModule?
    let sponsorCollaboratorsModule: SponsorCollaboratorsModule?
}

struct IdentificationModule: Codable {
    let nctId: String?
    let briefTitle: String?
}

struct StatusModule: Codable {
    let overallStatus: String?
}

struct DesignModule: Codable {
    let phases: [String]?
}

struct SponsorCollaboratorsModule: Codable {
    let leadSponsor: LeadSponsor?
}

struct LeadSponsor: Codable {
    let name: String?
}
