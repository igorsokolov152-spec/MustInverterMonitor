import Foundation

final class LocalPersistence {
    private let filename = "inverters.json"

    private var url: URL {
        let fm = FileManager.default
        let docs = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent(filename)
    }

    func save(devices: [Inverter]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(devices)
            try data.write(to: url, options: .atomic)
        } catch {
            print("Save error:", error)
        }
    }

    func loadDevices() -> [Inverter]? {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: url)
            let loaded = try decoder.decode([Inverter].self, from: data)
            return loaded
        } catch {
            print("Load error:", error)
            return nil
        }
    }
}
