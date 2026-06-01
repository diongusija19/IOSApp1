import Foundation

/// Snapshot of a completed Tim Hortons run for simple local history.
struct CoffeeRunRecord: Codable, Identifiable, Hashable {
    let id: UUID
    let completedAt: Date
    let orders: [TeamOrder]
    let totalEstimatedCost: Double

    init(id: UUID = UUID(), completedAt: Date = Date(), orders: [TeamOrder], totalEstimatedCost: Double) {
        self.id = id
        self.completedAt = completedAt
        self.orders = orders
        self.totalEstimatedCost = totalEstimatedCost
    }
}
