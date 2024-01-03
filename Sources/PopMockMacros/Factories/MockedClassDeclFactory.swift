import SwiftSyntax

struct MockedClassDeclFactory {
    func makeClass(protocolName: TokenSyntax, extensionDecl: ExtensionDeclSyntax) -> ClassDeclSyntax {
        ClassDeclSyntax(
            leadingTrivia: .init(stringLiteral: "final "),
            name: .init(stringLiteral: "\(protocolName.text)Mocked: \(protocolName.text)"),
            memberBlockBuilder: {
                let functions = extensionDecl.memberBlock.members
                    .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
                let variables = extensionDecl.memberBlock.members
                    .compactMap { $0.decl.as(VariableDeclSyntax.self) }

                FunctionMockableDeclarationFactory().mockImplementations(for: functions)
                MockVariableDeclarationFactory().mockVariableBodies(variables)
                FunctionMockableDeclarationFactory().callTrackerDeclarations(functions)
                MockVariableDeclarationFactory().mockVariableDeclarations(variables)
            }
        )
    }

    func makeProtocol(protocname: TokenSyntax, extensionDecl: ExtensionDeclSyntax) -> ProtocolDeclSyntax {
        ProtocolDeclSyntax(name: protocname) {
            let functions = extensionDecl.memberBlock.members
                .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            FunctionMockableDeclarationFactory().protoDeclarations(functions: functions)
            let variables = extensionDecl.memberBlock.members
                .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            FunctionMockableDeclarationFactory().protoDeclarations(variables: variables)
        }
    }
}
