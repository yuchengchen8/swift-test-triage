# Swift Test Triage

A small Swift command-line project that turns structured test results into a Markdown summary for a ticket or CI job. It counts outcomes, calculates a pass rate over executed tests, and groups failures by suite so a reviewer can see where to start.

## Run locally

Swift 5.9 or newer is required. The package has no external dependencies.

```sh
swift test
swift run test-triage Examples/results.json
```

The input is a JSON object with a `tests` array. Each entry needs a nonempty `suite`, a nonempty `name`, and a `status` of `passed`, `failed`, or `skipped`. Malformed inputs return a nonzero exit status. A failing test recorded in valid input appears in the summary and still produces a successful report.

## Scope

The included results are synthetic. The tool formats test results after execution and runs locally without a Jira integration or access to employer systems. The first implementation was generated with AI assistance as a Swift and XCTest practice project.
