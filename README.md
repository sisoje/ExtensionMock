# PopMock macro - needs swift 5.10 toolchain for nested protocols

The good old way of writing clean code is:
- you write a protocol
- you write implementation
- you implement a mock for the test
- when you change a function signature in any of the 3 places you need to update it on other 2 places.

Should we really do this all boilerplate by hand and look at it sitting there in the code?

What if we focus on the REAL implementation and let the macro do the rest.

Writing super clean code with a macro:
- you implement a piece of functionality as an extension of your real class
- macro will generate a nested protocol
- macro will generate a nested mock class
- when you change function signature in the only one real implementation you have, then protocol and mock updates automatically.

# POP & Mock

Most projects use one protocol conformance per class. This is swift. We can write as many extensions as we want. And we will. SOLID principles at work.

That is why we do a POP mock with nested protocols.

### Example Code - Original

```
struct User {
    let id: String
    var name: String
}

struct Item {
    let id: String
    let title: String
}

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

### Example Code - Expanded

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

### Testing code

```
let mock = Networking.UserServiceMocked()
mock.getUserMock.block = { User(id: "1", name: "fake user") }
```

