@attached(
    member,
    names: arbitrary
)
public macro PopMock() = #externalMacro(
    module: "PopMockMacros",
    type: "PopMockMacro"
)
