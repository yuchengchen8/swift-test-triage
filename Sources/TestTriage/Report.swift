import Foundation

public enum Report {
    private enum Outcome: String, Decodable {
        case passed, failed, skipped
    }

    private struct TestCase: Decodable {
        let suite: String
        let name: String
        let status: Outcome
    }

    private struct TestRun: Decodable {
        let tests: [TestCase]
    }

    public static func markdown(from data: Data) throws -> String {
        let tests = try JSONDecoder().decode(TestRun.self, from: data).tests
        var passed = 0
        var skipped = 0
        var failures: [String: [String]] = [:]

        for test in tests {
            guard !test.suite.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  !test.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw ValidationError.emptyTestName
            }

            switch test.status {
            case .passed:
                passed += 1
            case .skipped:
                skipped += 1
            case .failed:
                failures[test.suite, default: []].append(test.name)
            }
        }

        let failed = tests.count - passed - skipped
        let executed = passed + failed
        let passRate = executed == 0 ? "N/A" : "\(Int((100.0 * Double(passed) / Double(executed)).rounded()))%"
        var lines = [
            "# Test Run Summary",
            "",
            "Passed: \(passed) | Failed: \(failed) | Skipped: \(skipped)",
            "Pass rate (excluding skipped): \(passRate)",
            "",
            "## Failures",
            "",
        ]

        if failures.isEmpty {
            lines.append("None.")
        } else {
            for (suite, names) in failures.sorted(by: { $0.key < $1.key }) {
                lines.append("- \(escaped(suite)) (\(names.count))")
                for name in names.sorted() {
                    lines.append("  - \(escaped(name))")
                }
            }
        }
        return lines.joined(separator: "\n") + "\n"
    }

    private static func escaped(_ value: String) -> String {
        let specialCharacters: Set<Character> = ["\\", "`", "*", "_", "[", "]", "<", ">", "~", "&", "|", "!"]
        return value.reduce(into: "") { result, character in
            if character.isNewline {
                result.append(" ")
                return
            }
            if specialCharacters.contains(character) {
                result.append("\\")
            }
            result.append(character)
        }
    }
}

private enum ValidationError: LocalizedError {
    case emptyTestName

    var errorDescription: String? {
        "Every test needs a nonempty suite and name."
    }
}
