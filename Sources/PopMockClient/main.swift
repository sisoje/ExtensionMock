import PopMock

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
    func deleteUser(_ id: String) async throws  {}
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
