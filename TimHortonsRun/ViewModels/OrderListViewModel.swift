import Foundation
import SwiftUI

/// Shared source of truth for order-related views.
final class OrderListViewModel: ObservableObject {
    @Published private(set) var teamOrders: [TeamOrder] = []

    @Published var coffeeRunTimeRemaining: Int = 300
    @Published var timerRunning = false

    private let store = OrderStore()
    private var timer: Timer?

    init() {
        teamOrders = store.load()

        if teamOrders.isEmpty {
            // Seed data makes prototyping easier for demos/tests.
            teamOrders = [
                TeamOrder(personName: "Alex", order: Order(drinkType: "Coffee", size: "Large", milk: "2%", sugarCount: 2, extras: "Double cup"), isFavorite: true),
                TeamOrder(personName: "Sam", order: Order(drinkType: "French Vanilla", size: "Medium", milk: "Regular", sugarCount: 0, extras: ""), isFavorite: false)
            ]
            persist()
        }
    }

    func addOrder(personName: String, order: Order) {
        let trimmed = personName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        teamOrders.append(TeamOrder(personName: trimmed, order: order))
        persist()
    }

    func updateOrder(_ updated: TeamOrder) {
        guard let index = teamOrders.firstIndex(where: { $0.id == updated.id }) else { return }
        teamOrders[index] = updated
        persist()
    }

    func deleteOrders(at offsets: IndexSet) {
        teamOrders.remove(atOffsets: offsets)
        persist()
    }

    func toggleFavorite(_ order: TeamOrder) {
        guard let index = teamOrders.firstIndex(where: { $0.id == order.id }) else { return }
        teamOrders[index].isFavorite.toggle()
        persist()
    }

    var favorites: [TeamOrder] {
        teamOrders.filter { $0.isFavorite }
    }

    func startCoffeeRunTimer() {
        timerRunning = true
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.coffeeRunTimeRemaining > 0 {
                self.coffeeRunTimeRemaining -= 1
            } else {
                self.stopCoffeeRunTimer(reset: false)
            }
        }
    }

    func stopCoffeeRunTimer(reset: Bool = true) {
        timer?.invalidate()
        timer = nil
        timerRunning = false

        if reset {
            coffeeRunTimeRemaining = 300
        }
    }

    func formattedRemainingTime() -> String {
        let minutes = coffeeRunTimeRemaining / 60
        let seconds = coffeeRunTimeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func persist() {
        store.save(teamOrders)
    }
}
