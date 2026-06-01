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

    /// Rough estimate used for run planning and assignment-level reporting.
    var estimatedPrice: Double {
        let basePrice: Double
        switch drinkType {
        case "Coffee": basePrice = 2.15
        case "Iced Capp": basePrice = 3.79
        case "Tea": basePrice = 2.05
        case "French Vanilla": basePrice = 3.15
        case "Hot Chocolate": basePrice = 2.95
        default: basePrice = 2.50
        }

        let sizeUpcharge: Double
        switch size {
        case "Small": sizeUpcharge = -0.10
        case "Medium": sizeUpcharge = 0.0
        case "Large": sizeUpcharge = 0.35
        case "Extra Large": sizeUpcharge = 0.60
        default: sizeUpcharge = 0.0
        }

        let sugarUpcharge = Double(max(0, sugarCount - 2)) * 0.10
        let extrasUpcharge = extras.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.0 : 0.30

        return max(1.0, basePrice + sizeUpcharge + sugarUpcharge + extrasUpcharge)
    }
}
