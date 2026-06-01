import Foundation
import SwiftUI

/// Shared source of truth for order-related views.
final class OrderListViewModel: ObservableObject {
    @Published private(set) var teamOrders: [TeamOrder] = []
    @Published private(set) var runHistory: [CoffeeRunRecord] = []

    @Published var coffeeRunTimeRemaining: Int = 300
    @Published var timerRunning = false

    private let orderStore = OrderStore(filename: "team-orders.json")
    private let historyStore = OrderStore(filename: "run-history.json")
    private var timer: Timer?

    init() {
        teamOrders = orderStore.load()
        runHistory = historyStore.loadRunHistory()

        if teamOrders.isEmpty {
            // Seed data makes prototyping easier for demos/tests.
            teamOrders = [
                TeamOrder(personName: "Alex", order: Order(drinkType: "Coffee", size: "Large", milk: "2%", sugarCount: 2, extras: "Double cup"), isFavorite: true),
                TeamOrder(personName: "Sam", order: Order(drinkType: "French Vanilla", size: "Medium", milk: "Regular", sugarCount: 0, extras: ""), isFavorite: false)
            ]
            persistOrders()
        }
    }

    func addOrder(personName: String, order: Order) {
        let trimmed = personName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        teamOrders.append(TeamOrder(personName: trimmed, order: order))
        persistOrders()
    }

    func updateOrder(_ updated: TeamOrder) {
        guard let index = teamOrders.firstIndex(where: { $0.id == updated.id }) else { return }
        teamOrders[index] = updated
        persistOrders()
    }

    func addOrderFromFavorite(_ favorite: TeamOrder) {
        addOrder(personName: favorite.personName, order: favorite.order)
    }

    func deleteOrders(at offsets: IndexSet) {
        teamOrders.remove(atOffsets: offsets)
        persistOrders()
    }

    func toggleFavorite(_ order: TeamOrder) {
        guard let index = teamOrders.firstIndex(where: { $0.id == order.id }) else { return }
        teamOrders[index].isFavorite.toggle()
        persistOrders()
    }

    var favorites: [TeamOrder] {
        teamOrders.filter { $0.isFavorite }
    }

    var totalEstimatedCost: Double {
        teamOrders.reduce(0.0) { $0 + $1.order.estimatedPrice }
    }

    func completeRun() {
        guard !teamOrders.isEmpty else { return }

        let run = CoffeeRunRecord(orders: teamOrders, totalEstimatedCost: totalEstimatedCost)
        runHistory.insert(run, at: 0)
        persistRunHistory()

        // Keep reusable favorites and clear one-off orders for the next run.
        teamOrders = teamOrders.filter { $0.isFavorite }
        persistOrders()

        stopCoffeeRunTimer(reset: true)
    }

    func clearHistory() {
        runHistory.removeAll()
        persistRunHistory()
    }

    func startCoffeeRunTimer() {
        timerRunning = true
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }

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

    private func persistOrders() {
        orderStore.save(teamOrders)
    }

    private func persistRunHistory() {
        historyStore.saveRunHistory(runHistory)
    }
}
