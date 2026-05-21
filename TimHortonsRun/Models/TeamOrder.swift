import Foundation

/// Stores one person's order and a reusable favorite flag.
struct TeamOrder: Codable, Identifiable, Hashable {
    let id: UUID
    var personName: String
    var order: Order
    var isFavorite: Bool

    init(id: UUID = UUID(), personName: String, order: Order, isFavorite: Bool = false) {
        self.id = id
        self.personName = personName
        self.order = order
        self.isFavorite = isFavorite
    }
}
