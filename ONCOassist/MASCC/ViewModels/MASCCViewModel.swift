//
//  MASCCViewModel.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import Foundation
import Combine

class MASCCViewModel: ObservableObject {
    
    let criteria = MASCCData.criteria
    
    @Published var selectedOptions: [Int?]
    
    @Published var errorMessage: String?
    
    @Published var score: Int?
    
    @Published var showResult = false
    
    init() {
        selectedOptions = Array(repeating: nil, count: criteria.count)
    }
    
    func calculateScore() {
        guard answeredAll() else {
            errorMessage = "Please answer all questions before calculating."
            return
        }

        var total = 0

        for (criterionIndex, optionIndex) in selectedOptions.enumerated() {
            if let optionIndex = optionIndex {
                total += criteria[criterionIndex].options[optionIndex].points
            }
        }

        score = total
        errorMessage = nil
        showResult = true
    }
    func answeredAll() -> Bool {
        !selectedOptions.contains(nil)
    }
    
    func reset() {
        selectedOptions = Array(repeating: nil, count: criteria.count)
        score = nil
        errorMessage = nil
        showResult = false
    }
}
