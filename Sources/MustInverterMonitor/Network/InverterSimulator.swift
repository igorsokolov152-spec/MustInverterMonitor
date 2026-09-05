import Foundation

final class InverterSimulator {
    static let shared = InverterSimulator()
    private var timers: [UUID: Timer] = [:]

    // Generates periodic metrics for an inverter and calls handler
    func startSimulating(inverter: Inverter, interval: TimeInterval = 3.0, onUpdate: @escaping (InverterMetrics)->Void) {
        stopSimulating(id: inverter.id)
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            let v = Double.random(in: 300...520) // voltage
            let i = Double.random(in: 0...30)    // current
            let p = v * i
            let t = Double.random(in: 25...60)   // temp
            let metrics = InverterMetrics(voltage: v, current: i, power: p, temperature: t, timestamp: Date())
            DispatchQueue.main.async {
                onUpdate(metrics)
            }
        }
        timers[inverter.id] = timer
        timer.fire()
    }

    func stopSimulating(id: UUID) {
        timers[id]?.invalidate()
        timers.removeValue(forKey: id)
    }
}
