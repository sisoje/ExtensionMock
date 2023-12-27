import SwiftSyntax

struct MockedVariableDeclFactory {
    func make(protocolName: TokenSyntax, typeName: TokenSyntax, from classDecl: ExtensionDeclSyntax) -> VariableDeclSyntax {
        return VariableDeclSyntax(
            bindingSpecifier: "static let",
            bindings: PatternBindingListSyntax(
                arrayLiteral:
                PatternBindingSyntax(
                    pattern: PatternSyntax(stringLiteral: "mocked\(protocolName)"),
                    initializer: InitializerClauseSyntax(value: ExprSyntax(stringLiteral: "\(typeName)()"))
                )
            )
        )
    }
}
