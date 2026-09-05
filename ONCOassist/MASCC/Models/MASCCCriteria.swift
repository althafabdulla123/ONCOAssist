//
//  MASCCCriteria.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import Foundation

struct MASCCOption {
    let title: String
    let points: Int
}

struct MASCCCriteria: Identifiable {
    let id = UUID()
    let title: String
    let options: [MASCCOption]
}
