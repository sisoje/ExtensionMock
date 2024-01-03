import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct PopMockMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let extensionDecl = declaration.as(ExtensionDeclSyntax.self) else { return [] }
        guard
            let fullName = extensionDecl.inheritanceClause?.inheritedTypes.trimmedDescription,
            let protocolName = fullName.components(separatedBy: ".").last else { return [] }
        return [
            DeclSyntax(MockedClassDeclFactory().makeProtocol(protocname: .identifier(protocolName), extensionDecl: extensionDecl)),
            DeclSyntax(MockedClassDeclFactory().makeClass(protocolName: .identifier(protocolName), extensionDecl: extensionDecl)),
        ]
    }
}

@main
struct PopMockPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        PopMockMacro.self,
    ]
}
