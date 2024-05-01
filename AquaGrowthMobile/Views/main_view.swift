import Foundation
import SwiftUI

struct MainView: View {
    @StateObject var bluetooth = bluetooth_viewmodel()  // Moved to StateObject for lifecycle management
    @StateObject var viewModel = main_viewmodel()
    @StateObject var plants = plant_viewmodel()
    @State private var showAlert = false

    var body: some View {
        // Check if the user is signed in (through Firebase Authentication)
        if viewModel.isSignedIn {
            TabView {
                HomeView()
                    .environmentObject(bluetooth)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                PlantView()
                    .environmentObject(bluetooth)
                    .environmentObject(plants)
                    .tabItem {
                        Label("Plant", systemImage: "leaf")
                    }
                SettingsView()
                    .environmentObject(bluetooth)
                    .tabItem {
                        Label("Account", systemImage: "person.crop.circle.fill")
                    }
            }
            .onAppear {
                plants.fetchPlants()  // Load plants
                
                if bluetooth.bluetoothModel.discoveredPeripherals.isEmpty{
                    print("Peripherals are empty")
                }
                for item in bluetooth.bluetoothModel.discoveredPeripherals{
                    
                    print(item.name)
                    if item.name == "AquaGrowth"{
                        bluetooth.connect(peripheral: item)
                    }
                }
//                bluetooth.startScanning() // Assuming you have a method to explicitly start scanning
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Bluetooth Connection"), message: Text(bluetooth.statusMessage), dismissButton: .default(Text("OK")))
            }
            .onReceive(bluetooth.$statusMessage) { newValue in
                if !newValue.isEmpty {
                    showAlert = true
                }
            }
        } else {
            // If the user is not signed in, redirect them to login view.
            LoginView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
