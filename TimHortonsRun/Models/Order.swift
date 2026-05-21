import Foundation

/// Represents a single Tim Hortons drink/food order.
struct Order: Codable, Identifiable, Hashable {
    let id: UUID
    var drinkType: String
    var size: String
    var milk: String
    var sugarCount: Int
    var extras: String

    init(
        id: UUID = UUID(),
        drinkType: String = "Coffee",
        size: String = "Medium",
        milk: String = "Regular",
        sugarCount: Int = 1,
        extras: String = ""
    ) {
        self.id = id
        self.drinkType = drinkType
        self.size = size
        self.milk = milk
        self.sugarCount = sugarCount
        self.extras = extras
    }

    var summaryText: String {
        let extrasText = extras.isEmpty ? "No extras" : extras
        return "\(size) \(drinkType), \(milk), \(sugarCount)x sugar, \(extrasText)"
    }
}
