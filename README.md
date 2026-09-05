# ONCOassist

An iOS app with two features:

- **Clinical Trials** — search studies from the [ClinicalTrials.gov v2 API](https://clinicaltrials.gov/data-api/api), with paginated results and a detail screen backed by a second API call.
- **MASCC** — a MASCC Risk Index calculator for febrile neutropenia, with scoring and risk interpretation.

Built with SwiftUI. No third-party dependencies.

## Requirements

- Xcode
- iOS 15.0 minimum deployment target
- iPhone and iPad (universal)

## Running

1. Open `ONCOassist.xcodeproj`
2. Run (⌘R)

No API key or configuration needed — the ClinicalTrials.gov API is public and unauthenticated. The Trials tab fetches on first appearance, so the simulator needs network access.

## Tests

⌘U, or run the `ONCOassistTests` target. Three tests, all offline:

- `MASCCViewModelTests` — the maximum score (26 / low risk) and a known high-risk combination (16)
- `ClinicalTrialsServiceTests` — decodes a bundled `sample_trials.json` fixture through the real response models

## Architecture

The project follows the MVVM architecture, with a clear separation between the UI, business logic, and data handling.

## Assumptions & trade-offs

**The iOS 15.0 floor rules out `NavigationStack`.** `NavigationStack` and value-based navigation are iOS 16+. On a 15.0 target, `NavigationView` with `.navigationViewStyle(.stack)` is the correct baseline, and `NavigationLink(isActive:)` is the only way to drive a push programmatically.


**No persistence or caching.**  
Clinical trial results are fetched from the API for each search to keep the displayed information current, especially for fields such as recruitment status. Caching could improve responsiveness, but it may also result in displaying outdated trial information.

## What I'd improve with more time

I would add lightweight caching to preserve recently fetched trial details and reduce unnecessary API calls.

Adding more tests would improve the stability and reliability of the application and provide greater confidence in its behaviour.

## Third-party libraries

No Third-party libraries are used in this project . Everything used is native.

## AI Tools

ChatGPT was used as a development and review aid during the project.

It was used to understand and study the ClinicalTrials.gov response JSON and create the corresponding Codable model classes. It was also used to help resolve a Swift concurrency issue related to `deinit` isolation when lowering the deployment target to iOS 15.0, which resulted in the use of `nonisolated deinit` in `MASCCViewModel`.

AI assistance was also used to review the finished code, improve the UI presentation, the logical correctness and refine the overall look and usability of the views.

The final implementation was reviewed and adapted for this project, and I understand the code and design decisions used in the submission.
