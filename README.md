# ONCOassist

A small iOS app with two features:

- **Clinical Trials** — search studies from the [ClinicalTrials.gov v2 API](https://clinicaltrials.gov/data-api/api), with paginated results and a detail screen backed by a second API call.
- **MASCC** — a MASCC Risk Index calculator for febrile neutropenia, with scoring and risk interpretation.

Built with **SwiftUI**. No third-party dependencies.

## Requirements

- Xcode 26.2 or later
- iOS 15.0 minimum deployment target
- iPhone and iPad (universal)

## Running

1. Open `ONCOassist.xcodeproj`
2. Select the `ONCOassist` scheme and any iOS 15+ simulator
3. Run (⌘R)

No API key or configuration needed — the ClinicalTrials.gov API is public and unauthenticated. The Trials tab fetches on first appearance, so the simulator needs network access.

## Tests

⌘U, or run the `ONCOassistTests` target. Three tests, all offline:

- `MASCCViewModelTests` — the maximum score (26 / low risk) and a known high-risk combination (16)
- `ClinicalTrialsServiceTests` — decodes a bundled `sample_trials.json` fixture through the real response models

Nothing in the suite touches the network, so it is deterministic and runs in CI without a live API. Verified passing on the iOS 15.5 simulator.

## Architecture

**MVVM**, organised by feature rather than by layer:

```
ONCOassist/
├── App/                  ONCOassistApp, DualTabView (tab container)
├── MASCC/
│   ├── Models/           MASCCCriteria, MASCCData (static criteria table)
│   ├── ViewModels/       MASCCViewModel
│   └── Views/            MASCCView, ResultView, InfoView
└── Trials/
    ├── Models/           Trial (list), TrialDetails (detail), ClinicalTrialModels (API DTOs)
    ├── Services/         ClinicalTrialsService (both endpoints + mapping)
    ├── ViewModels/       TrialsViewModel, TrialDetailsViewModel
    └── Views/            ClinicalTrialsView, TrialDetailView
```

Two decisions worth calling out.

**The API shape does not leak into the UI.** ClinicalTrials.gov returns deeply nested, heavily optional JSON — `protocolSection.identificationModule.nctId`, and so on across eight modules. Those `Codable` types live in `ClinicalTrialModels` and never leave the service. `ClinicalTrialsService` flattens them into two flat presentation structs — `Trial` for the list, `TrialDetails` for the detail screen — with non-optional fields and explicit fallbacks, so a view renders a value directly instead of unwrapping a five-level optional chain at the call site. If the API reshapes its response, the change is contained to one file.

**Two endpoints, two models.** The list calls `/studies` with a narrowed `fields` parameter, requesting only the five values a row displays. The detail screen calls `/studies/{nctId}` for the full record — summary, conditions, eligibility, enrolment, dates and location. Keeping these as separate models means the list payload stays small and the detail screen isn't limited to what the list happened to fetch.

**Concurrency.** The app target sets `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` (Xcode 26 default), so view models and services are implicitly main-actor isolated and `@Published` mutations from inside `Task` blocks are already on the main actor. That is why the code has no explicit `@MainActor` annotations.

## Assumptions & trade-offs

**The iOS 15.0 floor rules out `NavigationStack`.** `NavigationStack` and value-based navigation are iOS 16+. On a 15.0 target, `NavigationView` with `.navigationViewStyle(.stack)` is the correct baseline, and `NavigationLink(isActive:)` is the only way to drive a push programmatically — which the MASCC flow needs to navigate to the result after Calculate. Both are deprecated as of iOS 16, and both are deliberate. Branching on `#available(iOS 16)` would mean maintaining two navigation trees for an app this size, which I judged a poor trade.

**Search is submit-driven, not live.** The field fires on the return key. Live search without debouncing would issue a request per keystroke; adding debouncing was outside the time budget, so I chose the behaviour that doesn't abuse a public API.

**Pagination is token-based infinite scroll.** The API returns a `nextPageToken`; the list appends the next page when the last row appears. No manual "load more", no jump-to-page.

**The MASCC criteria are hardcoded.** MASCC is a fixed, published index — the seven criteria and their point values are reference data, not content to fetch or configure. They live in a static table in `MASCCData`.

**No persistence or caching.** Results are fetched fresh each launch. Given the domain — recruitment status changes — stale cached data seemed worse than a spinner.

**Errors are one message plus a retry.** Loading, empty and error states are distinguished, but offline / server error / decode failure are not. A deliberate simplification.

## What I'd improve with more time

**Correctness**

- `healthyVolunteers` maps `Bool?` via `== true ? "Yes" : "No"`, so a *missing* value renders as a definitive "No". For eligibility data that is misleading and should render "Not available", as the neighbouring fields do.
- The detail URL is built by interpolating into `URL(string:)!`. An unexpected identifier would crash rather than throw; it should go through `URLComponents` like the list endpoint.
- Only the first location is shown. Multi-site trials give no indication that other sites exist.
- Add `.navigationViewStyle(.stack)` to `ClinicalTrialsView`. `MASCCView` sets it, the Trials tab does not, so on iPad it falls back to the double-column style and renders the list in a sidebar beside an empty detail pane.
- Replace the pagination trigger: it string-compares each row's NCT ID against `trials.last` on every `onAppear`. An index or prefetch threshold is cheaper and less brittle.
- `detailedDescription` is decoded and mapped but never displayed — either surface it or drop it.
- Remove a leftover `print` in `ClinicalTrialsService`.

**Testability**

- Put `ClinicalTrialsService` behind a protocol and inject it. Both view models construct it inline, so neither can be tested without the network. This is the single change that would most improve the suite — it would cover pagination, token exhaustion and error paths.
- Add a fixture for the detail response. `sample_trials.json` covers the list shape only; the `Study` decode used by the detail screen is untested.
- Cover the MASCC boundary case (exactly 21, the low/high threshold) and the incomplete-answers validation path.

**UI**

- Fix dark mode. `ClinicalTrialsView` and `TrialDetailView` hardcode white in places where the rest of the app correctly uses `Color(.systemBackground)` / `Color(.systemGroupedBackground)`.
- Extract the status/phase display formatting into one helper — it is duplicated between list row and detail row and the copies have already drifted.
- Format dates for display; they currently render as raw API strings.
- Add debounced live search, accessibility labels, and Dynamic Type checks — the fixed-height cards will clip at larger text sizes.

**Performance**

- Because of default main-actor isolation, `JSONDecoder` runs on the main thread. Marking the service `nonisolated` would move parsing off it. Negligible for 20 records, but wrong by default.

## Third-party libraries

None. Everything used — `URLSession` with async/await, `Codable`, SwiftUI, Combine's `ObservableObject` — ships with the platform. For an app this size a dependency would add build and review overhead without removing meaningful code.

## AI tools

<!-- CONFIRM THIS SECTION BEFORE SUBMITTING -->

The application code is hand-written. I used an AI assistant in two places: resolving a Swift concurrency
issue around `deinit` isolation when I lowered the deployment target to iOS 15.0, which produced the
`nonisolated deinit` in `MASCCViewModel`; and reviewing the finished code, which is where several items
in the "what I'd improve" section came from.
