import Foundation
import TestTriage

let arguments = CommandLine.arguments.dropFirst()
if arguments.count == 1, arguments.first == "--help" {
    print("Usage: test-triage <results.json>")
    exit(0)
}

guard arguments.count == 1, let path = arguments.first else {
    FileHandle.standardError.write(Data("Usage: test-triage <results.json>\n".utf8))
    exit(2)
}

do {
    let data = try Data(contentsOf: URL(fileURLWithPath: path))
    print(try Report.markdown(from: data), terminator: "")
} catch {
    FileHandle.standardError.write(Data("Could not generate test report: \(error.localizedDescription)\n".utf8))
    exit(1)
}
