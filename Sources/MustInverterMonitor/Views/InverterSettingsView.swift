import SwiftUI

struct InverterSettingsView: View {
    @ObservedObject var inverter: Inverter
    @Environment(\.dismiss) var dismiss
    @State private var localSettings: InverterSettings

    init(inverter: Inverter) {
        self.inverter = inverter
        _localSettings = State(initialValue: inverter.settings)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Operation")) {
                    Picker("Grid Mode", selection: $localSettings.gridMode) {
                        Text("On").tag("On")
                        Text("Off").tag("Off")
                        Text("Float").tag("Float")
                    }.pickerStyle(.segmented)

                    Stepper("Battery limit: \(localSettings.batteryChargeLimit)%", value: $localSettings.batteryChargeLimit, in: 0...100)

                    HStack {
                        Text("Frequency")
                        Spacer()
                        Text(String(format: "%.1f Hz", localSettings.outputFrequency))
                    }
                    Slider(value: $localSettings.outputFrequency, in: 45...65, step: 0.1)
                }

                Section {
                    Button("Apply") {
                        Task {
                            do {
                                try await InverterClient.shared.apply(settings: localSettings, to: inverter)
                                inverter.settings = localSettings
                                dismiss()
                            } catch {
                                // show alert (omitted for brevity)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
