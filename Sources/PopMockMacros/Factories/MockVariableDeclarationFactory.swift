import SwiftSyntax
import SwiftSyntaxBuilder

struct MockVariableDeclarationFactory {
    @MemberBlockItemListBuilder
    func mockVariableDeclarations(_ variables: [VariableDeclSyntax]) -> MemberBlockItemListSyntax {
        for variable in variables {
            mockVariableDeclaration(variable)
        }
    }

    @MemberBlockItemListBuilder
    func mockVariableDeclaration(_ variable: VariableDeclSyntax) -> MemberBlockItemListSyntax {
        if let binding = variable.bindings.first, let type = binding.typeAnnotation?.type.trimmedDescription {
            
            let pat: PatternSyntax = "\(raw: binding.pattern.trimmedDescription)Mock"
            VariableDeclSyntax(
                bindingSpecifier: .keyword(.var),
                bindings: .init(
                    arrayLiteral: PatternBindingSyntax(
                        pattern: pat,
                        //typeAnnotation: TypeAnnotationSyntax(type: TypeSyntax(stringLiteral: "MockVariable<\(type)>")),
                        initializer: InitializerClauseSyntax(value: ExprSyntax(stringLiteral: "MockVariable<\(type)>()"))
                    )
                )
            )
        }
    }
    
    @MemberBlockItemListBuilder
    func mockVariableDeclarations2(_ variables: [VariableDeclSyntax]) -> MemberBlockItemListSyntax {
        for variable in variables {
            mockVariableDeclaration2(variable)
        }
    }
    
    @MemberBlockItemListBuilder
    func mockVariableDeclaration2(_ variable: VariableDeclSyntax) -> MemberBlockItemListSyntax {
        if let binding = variable.bindings.first, let type = binding.typeAnnotation?.type.description {
            VariableDeclSyntax(
                bindingSpecifier: .keyword(.var),
                bindings: .init(
                    arrayLiteral: PatternBindingSyntax(
                        pattern: binding.pattern,
                        typeAnnotation: TypeAnnotationSyntax(type: TypeSyntax(stringLiteral: type)),
                        initializer: InitializerClauseSyntax(equal: "", value: ExprSyntax(stringLiteral: "{ get { \( binding.pattern)Mock.getter.record() } set { \( binding.pattern)Mock.setter.record(newValue) }  }"))
                    )
                )
            )
        }
    }
}
