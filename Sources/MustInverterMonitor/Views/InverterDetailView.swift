import SwiftUI

struct InverterDetailView: View {
    @ObservedObject var inverter: Inverter
    @EnvironmentObject var vm: DeviceListViewModel
    @State private var isMonitoring = true
    @State private var showingSettings = false

    var body: some View {
        VStack {
            if let m = inverter.lastMetrics {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Voltage").font(.caption)
                            Text(String(format: "%.1f V", m.voltage)).font(.title2)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Current").font(.caption)
                            Text(String(format: "%.2f A", m.current)).font(.title2)
                        }
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Power").font(.caption)
                            Text(String(format: "%.0f W", m.power)).font(.title)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Temp").font(.caption)
                            Text(String(format: "%.1f ℃", m.temperature)).font(.title2)
                        }
                    }
                    Text("Updated: \(m.timestamp.formatted(.dateTime.hour().minute().second()))")
                        .font(.caption).foregroundColor(.secondary)
                }
                .padding()
            } else {
                Text("Нет данных").foregroundColor(.secondary).padding()
            }

            Spacer()

            HStack {
                Button(isMonitoring ? "Остановить" : "Мониторить") {
                    isMonitoring.toggle()
                    if isMonitoring {
                        vm.startMonitoring(inverter)
                    } else {
                        vm.stopMonitoring(inverter)
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("Обновить") {
                    Task { await vm.refreshOnce(inverter) }
                }
                .buttonStyle(.bordered)
            }
            .padding()

        }
        .navigationTitle(inverter.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Настройки") { showingSettings = true }
            }
        }
        .onAppear {
            if isMonitoring { vm.startMonitoring(inverter) }
        }
        .onDisappear {
            vm.stopMonitoring(inverter)
        }
        .sheet(isPresented: $showingSettings) {
            InverterSettingsView(inverter: inverter)
        }
    }
}
