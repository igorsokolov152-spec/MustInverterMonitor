import SwiftUI

@main
struct MustInverterMonitorApp: App {
    @StateObject private var devicesVM = DeviceListViewModel()

    var body: some Scene {
        WindowGroup {
            DeviceListView()
                .environmentObject(devicesVM)
        }
    }
}
