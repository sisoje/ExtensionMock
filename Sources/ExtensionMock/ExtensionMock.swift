@attached(
    member,
    names: arbitrary
)
public macro ExtensionMock() = #externalMacro(
    module: "ExtensionMockMacros",
    type: "ExtensionMockMacro"
)
