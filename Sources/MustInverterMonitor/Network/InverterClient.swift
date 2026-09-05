import Foundation

enum InverterClientError: Error {
    case unreachable, invalidResponse
}

final class InverterClient {
    static let shared = InverterClient()

    // In реальной интеграции заменить на UDP/HTTP вызовы по спецификации устройства
    func fetchMetrics(for inverter: Inverter) async throws -> InverterMetrics {
        // Здесь мы симулируем получение через задержку; в будущем — реальные сетевые вызовы
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3s
        let v = Double.random(in: 300...520)
        let i = Double.random(in: 0...30)
        let p = v * i
        let t = Double.random(in: 25...60)
        return InverterMetrics(voltage: v, current: i, power: p, temperature: t, timestamp: Date())
    }

    func apply(settings: InverterSettings, to inverter: Inverter) async throws {
        // Simulate applying settings with delay; in real device - send UDP/HTTP command and validate response
        try await Task.sleep(nanoseconds: 200_000_000)
        // throw InverterClientError.unreachable // if needed
    }
}
