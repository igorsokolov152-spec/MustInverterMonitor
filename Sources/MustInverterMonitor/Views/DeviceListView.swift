import SwiftUI

struct DeviceListView: View {
    @EnvironmentObject var vm: DeviceListViewModel
    @State private var showingAdd = false
    @State private var newIP = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(vm.devices) { device in
                    NavigationLink(destination: InverterDetailView(inverter: device).environmentObject(vm)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(device.name).font(.headline)
                                Text("\(device.ip):\(device.port)").font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            if let m = device.lastMetrics {
                                VStack(alignment: .trailing) {
                                    Text(String(format: "%.0f W", m.power)).bold()
                                    Text(String(format: "%.1f ℃", m.temperature)).font(.caption)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onDelete(perform: vm.remove)
            }
            .navigationTitle("MUST Inverters")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                NavigationView {
                    Form {
                        Section(header: Text("New Inverter")) {
                            TextField("IP address", text: $newIP)
                        }
                    }
                    .navigationTitle("Add Inverter")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                vm.addDevice(ip: newIP)
                                showingAdd = false
                                newIP = ""
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingAdd = false }
                        }
                    }
                }
            }
        }
    }
}
