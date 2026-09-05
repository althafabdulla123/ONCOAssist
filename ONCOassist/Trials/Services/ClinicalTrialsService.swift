//
//  ClinicalTrialsService.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import Foundation

class ClinicalTrialsService {

    func fetchTrials(
        searchTerm: String,
        pageToken: String? = nil
    ) async throws -> (trials: [Trial], nextPageToken: String?) {

        guard var components = URLComponents(
            string: "https://clinicaltrials.gov/api/v2/studies"
        ) else {
            throw URLError(.badURL)
        }

        components.queryItems = [
           URLQueryItem(name: "query.cond", value: searchTerm),
           URLQueryItem(name: "pageSize", value: "20"),
           URLQueryItem(name: "fields",value: "NCTId,BriefTitle,OverallStatus,Phase,LeadSponsorName")
        ]

        if let pageToken = pageToken {
            components.queryItems?.append(URLQueryItem(name: "pageToken", value: pageToken))
        }
        print(components)

        let (data, response) = try await URLSession.shared.data(from: components.url!)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(
            TrialsResponse.self,
            from: data
        )

        var trials: [Trial] = []

        for study in result.studies {

            let section = study.protocolSection

            let trial = Trial(
                nctId: section.identificationModule?.nctId ?? "N/A",
                title: section.identificationModule?.briefTitle
                    ?? "Title unavailable",
                status: section.statusModule?.overallStatus
                    ?? "Status unavailable",
                phase: section.designModule?.phases?.first
                    ?? "Not applicable",
                sponsor: section.sponsorCollaboratorsModule?.leadSponsor?.name
                    ?? "Sponsor unavailable"
            )

            trials.append(trial)
        }

        return (
            trials: trials,
            nextPageToken: result.nextPageToken
        )
    }
    func fetchTrialDetails(nctId: String) async throws -> TrialDetails {

        let url = URL(
            string: "https://clinicaltrials.gov/api/v2/studies/\(nctId)"
        )!

        let (data, response) = try await URLSession.shared.data(
            from: url
        )

        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(
            Study.self,
            from: data
        )

        let section = result.protocolSection

        let location = section.contactsLocationsModule?.locations?.first

        return TrialDetails(
            nctId: section.identificationModule?.nctId ?? "N/A",
            briefTitle: section.identificationModule?.briefTitle
                ?? "Title unavailable",
            officialTitle: section.identificationModule?.officialTitle
                ?? "Not available",
            status: section.statusModule?.overallStatus
                ?? "Status unavailable",
            phase: section.designModule?.phases?.first
                ?? "NA",
            studyType: section.designModule?.studyType
                ?? "Not available",
            sponsor: section.sponsorCollaboratorsModule?.leadSponsor?.name
                ?? "Sponsor unavailable",
            summary: section.descriptionModule?.briefSummary
                ?? "No summary available",
            detailedDescription: section.descriptionModule?.detailedDescription
                ?? "No detailed description available",
            conditions: section.conditionsModule?.conditions
                ?? [],
            sex: section.eligibilityModule?.sex
                ?? "Not available",
            minimumAge: section.eligibilityModule?.minimumAge
                ?? "Not available",
            healthyVolunteers: section.eligibilityModule?.healthyVolunteers == true
                ? "Yes"
                : "No",
            enrollment: section.designModule?.enrollmentInfo?.count.map {
                String($0)
            } ?? "Not available",
            startDate: section.statusModule?.startDateStruct?.date
                ?? "Not available",
            completionDate: section.statusModule?.completionDateStruct?.date
                ?? "Not available",
            location: [
                location?.facility,
                location?.city,
                location?.state,
                location?.country
            ]
            .compactMap { $0 }
            .joined(separator: ", ")
        )
    }
}
