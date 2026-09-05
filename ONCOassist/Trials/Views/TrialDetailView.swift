//
//  TrialDetailView.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import SwiftUI

struct TrialDetailView: View {

    let NCTId: String

    @StateObject private var viewModel = TrialDetailsViewModel()

    var body: some View {

        ZStack {

            Color(.systemGray6)
                .ignoresSafeArea()

            if viewModel.isLoading {

                ProgressView("Loading trial...")

            } else if let error = viewModel.errorMessage {

                VStack(spacing: 12) {

                    Text(error)
                        .foregroundStyle(.secondary)

                    Button("Retry") {
                        viewModel.loadDetails(for:NCTId)
                    }
                }

            } else if let details = viewModel.details {

                ScrollView {

                    VStack(alignment: .leading, spacing: 28) {

                        Text(details.briefTitle)
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .padding(24)
                            .background(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 28)
                            )

                        VStack(spacing: 0) {

                            detailRow(
                                title: "NCT ID",
                                value: details.nctId
                            )

                            Divider()

                            detailRow(
                                title: "Status",
                                value: details.status
                                    .replacingOccurrences(
                                        of: "_",
                                        with: " "
                                    )
                                    .lowercased()
                                    .capitalized
                            )

                            Divider()

                            detailRow(
                                title: "Phase",
                                value: details.phase == "NA"
                                    || details.phase == "N/A"
                                    ? "Not Applicable"
                                    : details.phase
                                        .replacingOccurrences(
                                            of: "_",
                                            with: " "
                                        )
                                        .lowercased()
                                        .capitalized
                            )

                            Divider()

                            detailRow(
                                title: "Study Type",
                                value: details.studyType
                                    .lowercased()
                                    .capitalized
                            )

                            Divider()

                            detailRow(
                                title: "Lead sponsor",
                                value: details.sponsor
                            )

                            Divider()

                            detailRow(
                                title: "Enrollment",
                                value: details.enrollment
                            )

                            Divider()

                            detailRow(
                                title: "Start Date",
                                value: details.startDate
                            )

                            Divider()

                            detailRow(
                                title: "Completion Date",
                                value: details.completionDate
                            )
                        }
                        .padding(.horizontal, 24)
                        .background(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 28)
                        )

                        if !details.conditions.isEmpty {

                            detailSection(
                                title: "Conditions",
                                text: details.conditions.joined(
                                    separator: ", "
                                )
                            )
                        }

                        detailSection(
                            title: "Summary",
                            text: details.summary
                        )

                        VStack(alignment: .leading, spacing: 12) {

                            Text("Eligibility Information")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.horizontal,7)

                            VStack(spacing: 0) {

                                detailRow(
                                    title: "Sex",
                                    value: details.sex
                                )

                                Divider()

                                detailRow(
                                    title: "Minimum Age",
                                    value: details.minimumAge
                                )

                                Divider()

                                detailRow(
                                    title: "Healthy Volunteers",
                                    value: details.healthyVolunteers
                                )
                            }
                            .padding(.horizontal, 24)
                            .background(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 28)
                            )
                        }

                        if !details.location.isEmpty {

                            detailSection(
                                title: "Location",
                                text: details.location
                            )
                        }
                    }
                    .padding(10)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationTitle("Trial")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.details == nil {
                viewModel.loadDetails(for:NCTId)
            }
        }
    }

    private func detailRow(
        title: String,
        value: String
    ) -> some View {

        HStack(alignment: .top) {

            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 20)
    }

    private func detailSection(
        title: String,
        text: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal,7)

            Text(text)
                .padding(24)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .background(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 28)
                )
        }
    }
}
