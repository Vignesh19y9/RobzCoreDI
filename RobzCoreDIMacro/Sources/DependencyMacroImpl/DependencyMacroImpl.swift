import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct DependencyMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DependencyContainerImpl.self,
        DependencyRegisterImpl.self,
    ]
}
