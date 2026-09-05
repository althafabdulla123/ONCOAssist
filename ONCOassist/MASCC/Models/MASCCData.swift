//
//  MASCCData.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import Foundation

struct MASCCData {
    
    static let criteria: [MASCCCriteria] = [
        
        MASCCCriteria(
            title: "1. Burden of febrile neutropenia",
            options: [
                MASCCOption(title: "None / Mild", points: 5),
                MASCCOption(title: "Moderate", points: 3)
            ]
        ),
        
        MASCCCriteria(
            title: "2. No hypotension (systolic BP > 90 mmHg)",
            options: [
                MASCCOption(title: "Yes", points: 5),
                MASCCOption(title: "No", points: 0)
            ]
        ),
        
        MASCCCriteria(
            title: "3. No chronic obstructive pulmonary disease",
            options: [
                MASCCOption(title: "Yes", points: 4),
                MASCCOption(title: "No", points: 0)
            ]
        ),
        
        MASCCCriteria(
            title: "4. Solid tumour / no previous fungal infection",
            options: [
                MASCCOption(title: "Yes", points: 4),
                MASCCOption(title: "No", points: 0)
            ]
        ),
        
        MASCCCriteria(
            title: "5. No dehydration requiring IV fluids",
            options: [
                MASCCOption(title: "Yes", points: 3),
                MASCCOption(title: "No", points: 0)
            ]
        ),
        
        MASCCCriteria(
            title: "6. Outpatient status at onset of fever",
            options: [
                MASCCOption(title: "Yes", points: 3),
                MASCCOption(title: "No", points: 0)
            ]
        ),
        
        MASCCCriteria(
            title: "7. Age < 60 years",
            options: [
                MASCCOption(title: "Yes", points: 2),
                MASCCOption(title: "No", points: 0)
            ]
        )
    ]
}
