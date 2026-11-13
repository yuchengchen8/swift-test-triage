import Foundation
import TestTriage
import XCTest

final class ReportTests: XCTestCase {
    func testCountsAndGroupsFailuresInStableOrder() throws {
        let report = try makeReport("""
            {"tests":[
                {"suite":"Web","name":"Home","status":"passed"},
                {"suite":"Web","name":"Search","status":"failed"},
                {"suite":"API","name":"Write","status":"failed"},
                {"suite":"API","name":"Read","status":"failed"},
                {"suite":"Web","name":"Settings","status":"skipped"}
            ]}
            """)
        XCTAssertEqual(report, """
            # Test Run Summary

            Passed: 1 | Failed: 3 | Skipped: 1
            Pass rate (excluding skipped): 25%

            ## Failures

            - API (2)
              - Read
              - Write
            - Web (1)
              - Search

            """)
    }

    func testAllSkippedHasNoPassRate() throws {
        let report = try makeReport("""
            {"tests":[{"suite":"API","name":"Read","status":"skipped"}]}
            """)
        XCTAssertTrue(report.contains("Pass rate (excluding skipped): N/A"))
        XCTAssertTrue(report.hasSuffix("None.\n"))
    }

    func testUnknownOutcomeFailsDecoding() {
        XCTAssertThrowsError(try makeReport("""
            {"tests":[{"suite":"API","name":"Read","status":"pending"}]}
            """))
    }

    func testWhitespaceOnlyNameIsRejected() {
        XCTAssertThrowsError(try makeReport("""
            {"tests":[{"suite":"API","name":" ","status":"failed"}]}
            """))
    }

    func testMarkdownEscaping() throws {
        let report = try makeReport(#"""
            {"tests":[{"suite":"<UI>","name":"[unexpected]\nnew line","status":"failed"}]}
            """#)
        XCTAssertTrue(report.contains(#"- \<UI\> (1)"#))
        XCTAssertTrue(report.contains(#"  - \[unexpected\] new line"#))
    }

    private func makeReport(_ json: String) throws -> String {
        try Report.markdown(from: Data(json.utf8))
    }
}
