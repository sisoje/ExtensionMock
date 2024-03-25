import ExtensionMock

struct User {
    let id: String
    var name: String
}

struct Item {
    let id: String
    let title: String
}

class Networking {}

@ExtensionMock
extension Networking: Networking.UserService {
    var number: Int { 55 }
    func deleteUser(_ id: String) async throws  {}
    func getUser(_ id: String) async throws -> User  {
        User(id: "1", name: "real user")
    }
}

@ExtensionMock
extension Networking: Networking.ItemService {
    func getItem(_ id: String) async throws -> Item  {
        Item(id: "1", title: "real item")
    }
}
