//
//  MASCCView.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import SwiftUI

struct MASCCView: View {
    
    @StateObject private var viewModel = MASCCViewModel()
    @State private var showingInfo = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                
                ScrollView {
                    VStack(spacing: 18) {
                        
                        ForEach(viewModel.criteria.indices, id: \.self) { index in
                            criterionCard(index: index)
                        }
                        
                        Spacer()
                            .frame(height: 90)
                    }
                    .padding(.top, 10)
                }
                .background(Color(.systemGroupedBackground))
                
                Button {
                    viewModel.calculateScore()
                } label: {
                    Text("Calculate Score")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(
                            viewModel.answeredAll()
                            ? Color.green
                            : Color.gray
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                        .shadow(
                            color: .black.opacity(0.20),
                            radius: 10,
                            y: 4
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                NavigationLink(
                    destination: ResultView(
                        viewModel: viewModel, score: viewModel.score ?? 0
                    ),
                    isActive: $viewModel.showResult
                ) {
                    EmptyView()
                }
            }
            .navigationTitle("MASCC Risk Index")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        viewModel.reset()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            
            .alert(
                "Incomplete",
                isPresented: Binding(
                    get: {
                        viewModel.errorMessage != nil
                    },
                    set: { _ in
                        viewModel.errorMessage = nil
                    }
                )
            ) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            
            .sheet(isPresented: $showingInfo) {
                InfoView()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    
    @ViewBuilder
    private func criterionCard(index: Int) -> some View {
        let criterion = viewModel.criteria[index]
        
        VStack(alignment: .leading, spacing: 18) {
            
            Text(criterion.title)
                .font(.title3)
                .fontWeight(.medium)
            
            HStack(spacing: 14) {
                
                ForEach(criterion.options.indices, id: \.self) { optionIndex in
                    
                    let option = criterion.options[optionIndex]
                    let selected = viewModel.selectedOptions[index] == optionIndex
                    
                    Button {
                        viewModel.selectedOptions[index] = optionIndex
                    } label: {
                        VStack(spacing: 6) {
                            
                            Text(option.title)
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Text("\(option.points) points")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .foregroundStyle(
                            selected ? .white : .primary
                        )
                        .background(
                            selected
                            ? Color.blue
                            : Color(.systemGray6)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    Color.blue.opacity(0.35),
                                    lineWidth: 2
                                )
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                    }
                }
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .clipShape(
            RoundedRectangle(cornerRadius: 28)
        )
        .shadow(
            color: .black.opacity(0.05),
            radius: 8,
            y: 3
        )
        .padding(.horizontal, 4)
    }
}

