import Foundation

struct InverterSettings: Codable, Equatable {
    var gridMode: String = "On"
    var batteryChargeLimit: Int = 100
    var outputFrequency: Double = 50.0
}

struct InverterMetrics: Codable {
    var voltage: Double
    var current: Double
    var power: Double
    var temperature: Double
    var timestamp: Date
}

final class Inverter: Identifiable, ObservableObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, ip, port, model, serial, settings, lastMetrics
    }

    @Published var id: UUID
    @Published var name: String
    @Published var ip: String
    @Published var port: Int
    @Published var model: String
    @Published var serial: String
    @Published var settings: InverterSettings
    @Published var lastMetrics: InverterMetrics?

    init(id: UUID = UUID(),
         name: String,
         ip: String,
         port: Int = 80,
         model: String = "PV18-6248 ECO",
         serial: String = UUID().uuidString,
         settings: InverterSettings = InverterSettings(),
         lastMetrics: InverterMetrics? = nil) {
        self.id = id
        self.name = name
        self.ip = ip
        self.port = port
        self.model = model
        self.serial = serial
        self.settings = settings
        self.lastMetrics = lastMetrics
    }

    // Codable conformance (custom because of @Published)
    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        ip = try c.decode(String.self, forKey: .ip)
        port = try c.decode(Int.self, forKey: .port)
        model = try c.decode(String.self, forKey: .model)
        serial = try c.decode(String.self, forKey: .serial)
        settings = try c.decode(InverterSettings.self, forKey: .settings)
        lastMetrics = try c.decodeIfPresent(InverterMetrics.self, forKey: .lastMetrics)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(ip, forKey: .ip)
        try c.encode(port, forKey: .port)
        try c.encode(model, forKey: .model)
        try c.encode(serial, forKey: .serial)
        try c.encode(settings, forKey: .settings)
        try c.encodeIfPresent(lastMetrics, forKey: .lastMetrics)
    }
}
