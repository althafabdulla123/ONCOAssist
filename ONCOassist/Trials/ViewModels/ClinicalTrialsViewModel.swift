//
//  ClinicalTrialsViewModel.swift.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import Foundation
import Combine

class TrialsViewModel: ObservableObject {

    @Published var trials: [Trial] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?

    private let service = ClinicalTrialsService()

    private var nextPageToken: String?

    func loadTrials() {

        isLoading = true
        errorMessage = nil
        nextPageToken = nil

        Task {
            do {
                let result = try await service.fetchTrials(searchTerm: searchText)
                self.trials = result.trials
                self.nextPageToken = result.nextPageToken
                self.isLoading = false

            } catch {
                self.errorMessage = "Unable to load clinical trials."
                self.isLoading = false
            }
        }
    }

    func loadMoreTrials() {

        guard let token = nextPageToken,
              !isLoadingMore else {
            return
        }

        isLoadingMore = true

        Task {
            do {
                let result = try await service.fetchTrials(searchTerm: searchText,pageToken: token)
                self.trials.append(contentsOf: result.trials)
                self.nextPageToken = result.nextPageToken
                self.isLoadingMore = false

            } catch {
                self.isLoadingMore = false
            }
        }
    }
}
