import XcodeKit

final class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void) {
        ActionTracker.shared.recordEdit(lineCount: invocation.buffer.lines.count)
        let iso = ISO8601DateFormatter().string(from: Date())
        let fileName = (invocation.buffer.completeBuffer as NSString).lastPathComponent
        let insertion = "// 🏆 XcodeTrophies ran at \(iso) for \(fileName)\n"
        invocation.buffer.lines.insert(insertion, at: 0)
        completionHandler(nil)
    }
}

