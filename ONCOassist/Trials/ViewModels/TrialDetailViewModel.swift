//
//  TrialDetailViewModel.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import Foundation
import Combine

class TrialDetailsViewModel: ObservableObject {

    @Published var details: TrialDetails?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = ClinicalTrialsService()

    func loadDetails(for nctId: String) {
        
        isLoading = true
        errorMessage = nil
        Task {

            do {

                let result = try await service.fetchTrialDetails(nctId: nctId)
                self.details = result
                self.isLoading = false

            } catch {

                self.errorMessage = "Unable to load trial details."
                self.isLoading = false
            }
        }
    }
}
