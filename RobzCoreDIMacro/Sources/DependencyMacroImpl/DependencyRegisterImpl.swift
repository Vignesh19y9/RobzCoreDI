import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics
import SwiftSyntaxBuilder

public struct DependencyRegisterImpl: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Skip declarations other than variables
        guard let varDecl = declaration.as(VariableDeclSyntax.self) else {
            return []
        }

        guard var binding = varDecl.bindings.first else {
            context.diagnose(Diagnostic(node: Syntax(node), message: DependencyMacroError.missingAnnotation))
            return []
        }

        guard (binding.pattern.as(IdentifierPatternSyntax.self)?.identifier) != nil else {
            context.diagnose(Diagnostic(node: Syntax(node), message: DependencyMacroError.notAnIdentifier))
            return []
        }
        
        binding.pattern = PatternSyntax(IdentifierPatternSyntax(identifier: .identifier("value")))

        let isOptionalType = binding.typeAnnotation?.type.is(OptionalTypeSyntax.self) ?? false
        let hasDefaultValue = binding.initializer != nil
        
        guard isOptionalType || hasDefaultValue else {
            context.diagnose(Diagnostic(node: Syntax(node), message: DependencyMacroError.noDefaultArgument))
            return []
        }
        
        return [
            """
            private enum \(raw: binding.typeAnnotation?.type.description.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")DependencyKey: DependencyKey {
                static let \(binding.pattern)\(raw: binding.typeAnnotation?.description ?? "")\(raw: binding.initializer?.equal.description ?? ""){ \(raw: binding.initializer?.value.description ?? "")\(raw: isOptionalType && !hasDefaultValue ? "nil" : "") }()
            }
            """
        ]
    }
}

extension DependencyRegisterImpl: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {

        // Skip declarations other than variables
        guard let varDecl = declaration.as(VariableDeclSyntax.self) else {
            return []
        }

        guard let binding = varDecl.bindings.first else {
            context.diagnose(Diagnostic(node: Syntax(node), message: DependencyMacroError.missingAnnotation))
            return []
        }

        guard let identifier = binding.typeAnnotation?.type.description.trimmingCharacters(in: .whitespacesAndNewlines) else {
            context.diagnose(Diagnostic(node: Syntax(node), message: DependencyMacroError.notAnIdentifier))
            return []
        }

        return [
            """
            get {
                self[\(raw: identifier)DependencyKey.self]
            }
            """,
            """
            set {
                self[\(raw: identifier)DependencyKey.self] = newValue
            }
            """
        ]
    }
}

