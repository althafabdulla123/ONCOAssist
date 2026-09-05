//
//  InfoView.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 45))
                    .foregroundStyle(.blue)
                
                Text("MASCC Risk Index")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(
                    "The MASCC Risk Index is used to assess the risk of serious complications from febrile neutropenia in cancer patients."
                )
                .foregroundStyle(.secondary)
                
                Divider()
                
                Text("Score interpretation")
                    .font(.headline)
                
                Text("Maximum score: 26")
                
                Text("Score ≥ 21")
                    .fontWeight(.semibold)
                
                Text("LOW risk of serious complications.")
                    .foregroundStyle(.secondary)
                
                Text("Score < 21")
                    .fontWeight(.semibold)
                
                Text("HIGH risk of serious complications.")
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            .padding(24)
            .navigationTitle("Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
