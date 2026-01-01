import XcodeKit

final class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey : Any]] {
        [[
            .identifierKey: "com.webdmg.xcodetrophies.trackAction",
            .classNameKey: NSStringFromClass(SourceEditorCommand.self),
            .nameKey: "Track Coding Trophy Progress"
        ]]
    }
    
    func extensionDidFinishLaunching() {
        NSLog("XcodeTrophies SourceEditorExtension launched")
    }
}
