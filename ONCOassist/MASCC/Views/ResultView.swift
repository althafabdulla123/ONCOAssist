//
//  ResultView.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import SwiftUI

struct ResultView: View {
    
    @ObservedObject var viewModel: MASCCViewModel

    let score: Int
    
    @Environment(\.dismiss) private var dismiss
    
    var riskLevel: String {
        score < 21 ? "HIGH RISK" : "LOW RISK"
    }
    
    var riskColor: Color {
        score < 21 ? .red : .green
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                VStack(spacing: 12) {
                    
                    Text("\(score)")
                        .font(.system(size: 96, weight: .bold))
                        .foregroundStyle(riskColor)
                    
                    Text("of 26")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    Text(riskLevel)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(riskColor)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(
                            riskColor.opacity(0.12)
                        )
                        .clipShape(
                            Capsule()
                        )
                    
                    Text(
                        score < 21
                        ? "A score below 21 indicates a high risk of serious complications from febrile neutropenia."
                        : "A score of 21 or higher indicates a lower risk of serious complications from febrile neutropenia."
                    )
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity)
                .padding(32)
                .background(Color(.systemBackground))
                .clipShape(
                    RoundedRectangle(cornerRadius: 28)
                )
                .shadow(
                    color: .black.opacity(0.05),
                    radius: 8,
                    y: 3
                )
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("MASCC Score")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Your calculated MASCC Risk Index score is \(score) out of 26.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                Button {
                    viewModel.reset()
                    dismiss()
                    
                } label: {
                    Text("Start New")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.green)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}
