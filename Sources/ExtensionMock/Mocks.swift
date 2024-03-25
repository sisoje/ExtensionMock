//
//  File.swift
//
//
//  Created by Lazar Otasevic on 25.12.23..
//

import Foundation

public struct Mock<ArgumentType, ReturnType> {
    public init() {}
    public var block: ((ArgumentType) -> ReturnType)!
    public var callsHistory: [ArgumentType] = []
    public mutating func record(_ arguments: ArgumentType) -> ReturnType {
        callsHistory.append(arguments)
        return block(arguments)
    }
}

public struct MockVoid<ReturnType> {
    public init() {}
    public var block: (() -> ReturnType)!
    public var numberOfCalls = 0
    public mutating func record() -> ReturnType {
        numberOfCalls += 1
        return block()
    }
}

public struct MockThrowing<ArgumentType, ReturnType> {
    public init() {}
    public var block: ((ArgumentType) throws -> ReturnType)!
    public var callsHistory: [ArgumentType] = []
    public mutating func record(_ arguments: ArgumentType) throws -> ReturnType {
        callsHistory.append(arguments)
        return try block(arguments)
    }
}

public struct MockThrowingVoid<ReturnType> {
    public init() {}
    public var block: (() throws -> ReturnType)!
    public var numberOfCalls = 0
    public mutating func record() throws -> ReturnType {
        numberOfCalls += 1
        return try block()
    }
}

public struct MockAsyncThrowing<ArgumentType, ReturnType> {
    public init() {}
    public var block: ((ArgumentType) async throws -> ReturnType)!
    public var callsHistory: [ArgumentType] = []
    public mutating func record(_ arguments: ArgumentType) async throws -> ReturnType {
        callsHistory.append(arguments)
        return try await block(arguments)
    }
}

public struct MockAsyncThrowingVoid<ReturnType> {
    public init() {}
    public var block: (() async throws -> ReturnType)!
    public var numberOfCalls = 0
    public mutating func record() async throws -> ReturnType {
        numberOfCalls += 1
        return try await block()
    }
}

public struct MockAsync<ArgumentType, ReturnType> {
    public init() {}
    public var block: ((ArgumentType) async -> ReturnType)!
    public var callsHistory: [ArgumentType] = []
    public mutating func record(_ arguments: ArgumentType) async -> ReturnType {
        callsHistory.append(arguments)
        return await block(arguments)
    }
}

public struct MockAsyncVoid<ReturnType> {
    public init() {}
    public var block: (() async -> ReturnType)!
    public var numberOfCalls = 0
    public mutating func record() async -> ReturnType {
        numberOfCalls += 1
        return await block()
    }
}

public struct MockVariable<VarType> {
    public init() {}
    public var setter = Mock<VarType, Void>()
    public var getter = MockVoid<VarType>()
}
