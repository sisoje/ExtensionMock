import SwiftSyntax
import SwiftSyntaxBuilder

struct FunctionMockableDeclarationFactory {
    @MemberBlockItemListBuilder
    func callTrackerDeclarations(_ functions: [FunctionDeclSyntax]) -> MemberBlockItemListSyntax {
        for function in functions {
            let params: [GenericParameterSyntax] = function.signature.parameterClause.parameters
                .map { $0.type }
                .map { type in
                    let t = type.trimmedDescription.replacingOccurrences(of: "@escaping", with: "").trimmingCharacters(in: .whitespaces)
                    return GenericParameterSyntax(name: TokenSyntax(stringLiteral: t))
                }
            let returnType = function.signature.returnClause?.type.trimmedDescription ?? "Void"
            
            let pa = if params.count <= 1 {
                params.first?.trimmedDescription ?? "Void"
            } else {
                "(" + GenericParameterListSyntax(params).map { p in
                    p.trimmedDescription
                }.joined(separator: ", ") + ")"
            }
            
            let structName1 = if isAsyncThrowsFuction(function) {
                "MockAsyncThrowing"
            } else if isThrowingFuction(function) {
                "MockThrowing"
            } else if isAsyncFuction(function) {
                "MockAsync"
            } else {
                "Mock"
            }
            
            let structName = structName1 + (params.isEmpty ? "Void" : "")
            let templateParams = params.isEmpty ? returnType : "\(pa), \(returnType)"

            VariableDeclSyntax(
                modifiers: DeclModifierListSyntax([.init(name: .identifier(""))]),
                .var,
                name: PatternSyntax(stringLiteral: function.name.text + "Mock = \(structName)<\(templateParams)>()")
            )
        }
    }
    
    @MemberBlockItemListBuilder
    func mockImplementations(for functions: [FunctionDeclSyntax]) -> MemberBlockItemListSyntax {
        for function in functions {
            let paramsValues = function.signature.parameterClause.parameters
                .map {
                    $0.secondName?.text != nil ? $0.secondName!.text : $0.firstName.text
                }
            
            let tryStringLiteral = if isAsyncThrowsFuction(function) {
                "try await "
            } else if isThrowingFuction(function) {
                "try "
            } else if isAsyncFuction(function) {
                "await "
            } else {
                ""
            }
            
            FunctionDeclSyntax(
                attributes: function.attributes,
                modifiers: function.modifiers,
                funcKeyword: function.funcKeyword,
                name: function.name,
                genericParameterClause: function.genericParameterClause,
                signature: function.signature,
                genericWhereClause: function.genericWhereClause
            ) {
                if paramsValues.isEmpty {
                    CodeBlockItemSyntax(stringLiteral: tryStringLiteral + function.name.text + "Mock." + "record()")
                } else {
                    CodeBlockItemSyntax(stringLiteral: tryStringLiteral + function.name.text + "Mock." + "record((\(paramsValues.joined(separator: ", "))))")
                }
            }
        }
    }
    
    @MemberBlockItemListBuilder
    func protoDeclarations(for functions: [FunctionDeclSyntax]) -> MemberBlockItemListSyntax {
        for function in functions {
            FunctionDeclSyntax(
                attributes: function.attributes,
                modifiers: function.modifiers,
                funcKeyword: function.funcKeyword,
                name: function.name,
                genericParameterClause: function.genericParameterClause,
                signature: function.signature,
                genericWhereClause: function.genericWhereClause
            )
        }
    }
    
    @MemberBlockItemListBuilder
    func protoDeclarationsExt(for functions: [FunctionDeclSyntax]) -> MemberBlockItemListSyntax {
        for function in functions {
            FunctionDeclSyntax(
                attributes: function.attributes,
                modifiers: function.modifiers,
                funcKeyword: function.funcKeyword,
                name: function.name,
                genericParameterClause: function.genericParameterClause,
                signature: function.signature,
                genericWhereClause: function.genericWhereClause
            )
            {
                CodeBlockItemSyntax(stringLiteral: " fatalError() ")
            }
        }
    }
    
    private func isThrowingFuction(_ function: FunctionDeclSyntax) -> Bool {
        function.signature.effectSpecifiers?.throwsSpecifier?.text == "throws"
    }
    
    private func isAsyncFuction(_ function: FunctionDeclSyntax) -> Bool {
        function.signature.effectSpecifiers?.asyncSpecifier?.text == "async"
    }
    
    private func isAsyncThrowsFuction(_ function: FunctionDeclSyntax) -> Bool {
        isThrowingFuction(function) && isAsyncFuction(function)
    }
}
