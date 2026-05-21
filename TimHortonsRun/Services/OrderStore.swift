import Foundation

/// Handles loading/saving order data from local storage.
final class OrderStore {
    private let fileURL: URL

    init(filename: String = "team-orders.json") {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? FileManager.default.temporaryDirectory
        self.fileURL = documents.appendingPathComponent(filename)
    }

    func load() -> [TeamOrder] {
        guard let data = try? Data(contentsOf: fileURL) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([TeamOrder].self, from: data)) ?? []
    }

    func save(_ orders: [TeamOrder]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(orders) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
