# PopMock Macro - Requires Swift 5.10 Toolchain for Nested Protocols

The traditional approach to writing clean and testable code involves a few repetitive steps:
- Write a protocol.
- Implement the protocol.
- Create a mock based on the protocol for testing.
- When you change a method signature in one place, you must update the other two accordingly.

Does maintaining all this boilerplate by hand and having it clutter up our code sound ideal? What if we could concentrate on the actual implementation and let automation take care of the rest?

With the PopMock macro, you can embrace a cleaner code-writing process:
- Implement your functionality within an extension of the actual class.
- The macro automatically generates the relevant nested protocol.
- The macro creates a nested mock class to accompany it.
- Now, whenever you alter the method signature in the real implementation, the protocol and mock are updated automatically.

# POP & Mock

In many Swift projects, a single class might conform to one protocol. But Swift allows us the flexibility to write as many extensions as we wish—which is precisely what we will do, adhering to SOLID principles.

That’s where our PopMock comes into play, with its nested protocols for a clean POP mock setup.

### Example Code - Original

```
class Networking {}

@PopMock
extension Networking: Networking.UserService {
    func getUser(_ id: String) async throws -> User  {
        User(id: "1", name: "real user")
    }
}

@PopMock
extension Networking: Networking.ItemService {
    func getItem(_ id: String) async throws -> Item  {
        Item(id: "1", title: "real item")
    }
}
```

### Example Code - Macro Generated

```
extension Networking {
    protocol UserService {
        func getUser(_ id: String) async throws -> User
    }
    final class UserServiceMocked: UserService {
         var getUserMock = MockAsyncThrowing<String, User>()
         func getUser(_ id: String) async throws -> User  {
            try await getUserMock.record((id))
        }
    }
}

extension Networking {
    protocol ItemService {
        func getItem(_ id: String) async throws -> Item
    }
    final class ItemServiceMocked: ItemService {
         var getItemMock = MockAsyncThrowing<String, Item>()
         func getItem(_ id: String) async throws -> Item  {
            try await getItemMock.record((id))
        }
    }
}
```

### Example Code - Testing

```
let mock = Networking.UserServiceMocked()
mock.getUserMock.block = { User(id: "1", name: "fake user") }
```
