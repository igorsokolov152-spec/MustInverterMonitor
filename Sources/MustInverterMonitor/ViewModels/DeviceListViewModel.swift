import Foundation
import Combine

final class DeviceListViewModel: ObservableObject {
    @Published private(set) var devices: [Inverter] = []
    @Published var isScanning: Bool = false

    private let persistence = LocalPersistence()

    init() {
        load()
        if devices.isEmpty {
            // Seed with one simulated device for convenience
            let dev = Inverter(name: "PV18-6248 ECO #1", ip: "192.168.1.120", port: 80)
            devices = [dev]
            save()
        }
    }

    func addDevice(ip: String, name: String? = nil, port: Int = 80) {
        let inv = Inverter(name: name ?? "PV18-6248 ECO", ip: ip, port: port)
        devices.append(inv)
        save()
    }

    func remove(atOffsets offsets: IndexSet) {
        offsets.forEach { idx in
            let id = devices[idx].id
            InverterSimulator.shared.stopSimulating(id: id)
        }
        devices.remove(atOffsets: offsets)
        save()
    }

    func startMonitoring(_ inverter: Inverter) {
        InverterSimulator.shared.startSimulating(inverter: inverter) { [weak self, weak inverter] metrics in
            guard let inv = inverter else { return }
            inv.lastMetrics = metrics
            self?.save() // persist last state
        }
    }

    func stopMonitoring(_ inverter: Inverter) {
        InverterSimulator.shared.stopSimulating(id: inverter.id)
    }

    func refreshOnce(_ inverter: Inverter) async {
        do {
            let m = try await InverterClient.shared.fetchMetrics(for: inverter)
            DispatchQueue.main.async {
                inverter.lastMetrics = m
                self.save()
            }
        } catch {
            // handle errors (show alert in UI later)
        }
    }

    // Persistence
    func save() {
        persistence.save(devices: devices)
    }

    func load() {
        if let loaded = persistence.loadDevices() {
            self.devices = loaded
        }
    }
}
