import SwiftSyntax

struct MockedClassDeclFactory {
    func make(protocolName: TokenSyntax, from classDecl: ExtensionDeclSyntax) -> ClassDeclSyntax {
        ClassDeclSyntax(
            leadingTrivia: .init(stringLiteral: "final "),
            name: .init(stringLiteral: "\(protocolName.text)Mocked: \(protocolName.text)"),
            memberBlockBuilder: {
                let variables = classDecl.memberBlock.members
                    .compactMap { $0.decl.as(VariableDeclSyntax.self) }
                MockVariableDeclarationFactory().mockVariableDeclarations(variables)
                MockVariableDeclarationFactory().mockVariableDeclarations2(variables)
                
                let functions = classDecl.memberBlock.members
                    .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
                
                let functionsFactory = FunctionMockableDeclarationFactory()
                functionsFactory.callTrackerDeclarations(functions)
                functionsFactory.mockImplementations(for: functions)
            }
        )
    }
    
    func makeProto(protocname: TokenSyntax, from classDecl: ExtensionDeclSyntax) -> ProtocolDeclSyntax {
        ProtocolDeclSyntax(name: protocname) {
            let functions = classDecl.memberBlock.members
                .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            let functionsFactory = FunctionMockableDeclarationFactory()
            functionsFactory.protoDeclarations(for: functions)
        }
    }
    
    func makeProtoExt(protocname: TokenSyntax, from classDecl: ExtensionDeclSyntax) -> ExtensionDeclSyntax {
        ExtensionDeclSyntax(extendedType: TypeSyntax(stringLiteral: protocname.text)) {
            let functions = classDecl.memberBlock.members
                .compactMap { $0.decl.as(FunctionDeclSyntax.self) }
            let functionsFactory = FunctionMockableDeclarationFactory()
            functionsFactory.protoDeclarationsExt(for: functions)
        }
    }
}
