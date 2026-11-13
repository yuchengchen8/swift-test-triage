# Swift Test Triage

A personal Swift command-line project that turns structured test results into a Markdown summary for a ticket or CI job. It counts outcomes, calculates a pass rate over executed tests, and groups failures by suite so a reviewer can see where to start.

## Run locally

Swift 5.9 or newer is required. The package has no external dependencies.

```sh
swift test
swift run test-triage Examples/results.json
```

The input is a JSON object with a `tests` array. Each entry needs a nonempty `suite`, a nonempty `name`, and a `status` of `passed`, `failed`, or `skipped`. Malformed inputs return a nonzero exit status. A failing test recorded in valid input appears in the summary and still produces a successful report.

## Scope

The included results are synthetic. The tool formats test results after execution and runs locally without a Jira integration or access to employer systems.

## Resume reference

Use XYZ order for impact bullets. Start with the outcome (X), give a verified measure or scope (Y), then explain the method (Z). For qualitative impact, name the observed change and how it happened. Only use figures that can be explained in an interview.

- Summarizes test runs across three outcomes by parsing JSON, grouping failures by suite, and reporting an executed-test pass rate in Markdown.
- Verifies reporting behavior with five passing XCTest cases covering failure grouping, all-skipped runs, unknown outcomes, blank names, and Markdown escaping.

The three outcomes and five tests describe project scope. The sample pass rate comes from synthetic data.
