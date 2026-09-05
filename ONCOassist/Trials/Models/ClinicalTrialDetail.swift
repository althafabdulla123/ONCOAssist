//
//  ClinicalTrialDetail.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import Foundation

struct TrialDetails {
    let nctId: String
    let briefTitle: String
    let officialTitle: String
    let status: String
    let phase: String
    let studyType: String
    let sponsor: String
    let summary: String
    let detailedDescription: String
    let conditions: [String]
    let sex: String
    let minimumAge: String
    let healthyVolunteers: String
    let enrollment: String
    let startDate: String
    let completionDate: String
    let location: String
}
