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
    let descriptionModule: DescriptionModule?
    let conditionsModule: ConditionsModule?
    let eligibilityModule: EligibilityModule?
    let contactsLocationsModule: ContactsLocationsModule?
}

struct IdentificationModule: Codable {
    let nctId: String?
    let briefTitle: String?
    let officialTitle: String?
}

struct StatusModule: Codable {
    let overallStatus: String?
    let startDateStruct: DateStruct?
    let completionDateStruct: DateStruct?
}

struct DesignModule: Codable {
    let phases: [String]?
    let studyType: String?
    let enrollmentInfo: EnrollmentInfo?
}

struct SponsorCollaboratorsModule: Codable {
    let leadSponsor: LeadSponsor?
}

struct LeadSponsor: Codable {
    let name: String?
}
struct DescriptionModule: Codable {
    let briefSummary: String?
    let detailedDescription: String?
}

struct ConditionsModule: Codable {
    let conditions: [String]?
}

struct EligibilityModule: Codable {
    let healthyVolunteers: Bool?
    let sex: String?
    let minimumAge: String?
}

struct ContactsLocationsModule: Codable {
    let locations: [Location]?
}

struct Location: Codable {
    let facility: String?
    let city: String?
    let state: String?
    let country: String?
}

struct DateStruct: Codable {
    let date: String?
}

struct EnrollmentInfo: Codable {
    let count: Int?
}
