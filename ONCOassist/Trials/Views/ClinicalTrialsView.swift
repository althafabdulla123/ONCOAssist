//
//  ClinicalTrialsView.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import SwiftUI

struct ClinicalTrialsView: View {

    @StateObject private var viewModel = TrialsViewModel()
    @State private var showSearch = false

    var body: some View {

        NavigationView {

            ZStack(alignment: .bottom) {

                Color.white.ignoresSafeArea()

                VStack(spacing: 0) {

                    HStack {

                        Text("Clinical Trials")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Spacer()

                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showSearch.toggle()
                            }
                        } label: {
                            Image(systemName: showSearch ? "xmark" : "magnifyingglass")
                            .font(.title2)
                            .foregroundStyle(.primary)
                            .frame(width: 58, height: 58)
                            .background(.white)
                            .clipShape(Circle())
                            .shadow(
                                color: .black.opacity(0.08),
                                radius: 10,
                                y: 4
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 16)

                    if showSearch {

                        HStack(spacing: 10) {

                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)

                            TextField("Search clinical trials",text: $viewModel.searchText)
                            .textFieldStyle(.plain)
                            .submitLabel(.search)
                            .onSubmit {
                                viewModel.loadTrials()
                            }

                            if !viewModel.searchText.isEmpty {

                                Button {
                                    viewModel.searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal, 14)
                        .frame(height: 46)
                        .background(Color(.systemGray6))
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )
                        .padding(.horizontal, 24)
                        .padding(.bottom, 12)
                        .transition(
                            .move(edge: .top)
                            .combined(with: .opacity)
                        )
                    }

                    if viewModel.isLoading {

                        Spacer()

                        ProgressView("Loading trials...")

                        Spacer()

                    } else if let error = viewModel.errorMessage {

                        Spacer()

                        VStack(spacing: 12) {

                            Text(error)
                            .foregroundStyle(.secondary)

                            Button("Retry") {
                                viewModel.loadTrials()
                            }
                        }

                        Spacer()

                    } else if viewModel.trials.isEmpty {

                        Spacer()

                        Text("No clinical trials found.")
                            .foregroundStyle(.secondary)

                        Spacer()

                    } else {

                        ScrollView {

                            LazyVStack(spacing: 0) {

                                ForEach(viewModel.trials,id: \.nctId) { trial in

                                    NavigationLink {
                                        MASCCView()
                                    } label: {

                                        HStack(alignment: .top,spacing: 10) {

                                            VStack(alignment: .leading,spacing: 12) {

                                                Text(trial.title)
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                                    .foregroundStyle(.primary)

                                                HStack(spacing: 12) {

                                                    Text(
                                                        trial.status
                                                            .replacingOccurrences(of: "_",with: " ")
                                                            .lowercased()
                                                            .capitalized
                                                    )
                                                    .font(.caption)
                                                    .fontWeight(.medium)
                                                    .foregroundStyle(.blue)
                                                    .padding(.horizontal, 9)
                                                    .padding(.vertical, 5)
                                                    .background(
                                                        Color.blue.opacity(0.12)
                                                    )
                                                    .clipShape(Capsule())

                                                    Text(
                                                        trial.phase == "NA"
                                                            ? "Not Applicable"
                                                            : trial.phase
                                                                .replacingOccurrences(of: "_", with: " ")
                                                                .lowercased()
                                                                .capitalized
                                                    )
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                                }

                                                HStack(spacing: 8) {

                                                    Image(systemName: "building.columns")
                                                    .foregroundStyle(.secondary)

                                                    Text(trial.sponsor)
                                                        .font(.subheadline)
                                                        .foregroundStyle(.secondary)
                                                        .lineLimit(2)
                                                }

                                                Text(trial.nctId)
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                            }

                                            Spacer()

                                            VStack {
                                                Spacer()

                                                Image(systemName: "chevron.right")
                                                    .font(.body)
                                                    .foregroundStyle(.secondary)

                                                Spacer()
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 20)
                                    }
                                    .buttonStyle(.plain)
                                    .onAppear {
                                        if trial.nctId
                                            == viewModel.trials.last?.nctId {
                                            viewModel.loadMoreTrials()
                                        }
                                    }

                                    Divider()
                                        .padding(.horizontal, 16)
                                }

                                if viewModel.isLoadingMore {

                                    ProgressView()
                                        .padding()
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if viewModel.trials.isEmpty {
                    viewModel.loadTrials()
                }
            }
        }
    }
}
