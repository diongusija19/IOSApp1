import Foundation

/// Handles loading/saving order data from local storage.
final class OrderStore {
    private let fileURL: URL

    init(filename: String = "team-orders.json") {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? FileManager.default.temporaryDirectory
        self.fileURL = documents.appendingPathComponent(filename)
    }

    func load() -> [TeamOrder] {
        loadCodable([TeamOrder].self) ?? []
    }

    func save(_ orders: [TeamOrder]) {
        saveCodable(orders)
    }

    func loadRunHistory() -> [CoffeeRunRecord] {
        loadCodable([CoffeeRunRecord].self) ?? []
    }

    func saveRunHistory(_ history: [CoffeeRunRecord]) {
        saveCodable(history)
    }

    private func loadCodable<T: Decodable>(_ type: T.Type) -> T? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(type, from: data)
    }

    private func saveCodable<T: Encodable>(_ payload: T) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(payload) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
