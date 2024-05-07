//
//  profile_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var bluetooth: bluetooth_viewmodel
    @StateObject var viewModel = settings_viewmodel()
    @State private var showNavigationBar = true
    @Binding var isDeviceConnected: Bool // Binding to track device connection

    var body: some View {
        // Use NavigationStack to navigate between views
        NavigationStack {
            VStack {
                // Use Spacer to push the content to the top
                Spacer()
                
                ZStack {
                    // Set the green rectangle
                    Rectangle()
                        .fill(Color(red: 0.28, green: 0.59, blue: 0.17))
                        .frame(width: UIScreen.main.bounds.width, height: 500)
                        .position(x: UIScreen.main.bounds.width / 2, y: 80)
                    
                    Rectangle()
                        .fill(.white)
                        .frame(width: UIScreen.main.bounds.width, height: 640)
                        .position(x: UIScreen.main.bounds.width / 2, y: 550)
                    
                    Text("Settings")
                        .font(.system(size: 50))
                        .bold()
                        .position(x: UIScreen.main.bounds.width / 2, y: 70)
                        .foregroundColor(.white)
                    
                    Form {
                        Section(header: Text("Global Settings")) {
                            NavigationLink {
                                BluetoothView(isDeviceConnected: $isDeviceConnected)
                                    .toolbar(.hidden, for: .tabBar)
                            } label: {
                                Label("Bluetooth", systemImage: "antenna.radiowaves.left.and.right")
                            }
                            
                            NavigationLink {
                                AccountView()
                                    .toolbar(.hidden, for: .tabBar)
                            } label: {
                                Label("Account Settings", systemImage: "person.crop.circle")
                            }
                            NavigationLink {
                                HelpAndSupportView()
                                    .toolbar(.hidden, for: .tabBar)
                            } label: {
                                Label("Help and Support", systemImage: "questionmark.circle")
                            }
                            NavigationLink {
                                TestView()
                                    .environmentObject(bluetooth)
                                    .toolbar(.hidden, for: .tabBar)
                            } label: {
                                Label("Test Data", systemImage: "gearshape")
                            }
                            
                            
                        }
                        
                        Section {
                            Button(action: { viewModel.logOut() }) {
                                Text("Log Out")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 5) // Adjust vertical padding
                            }
                            .background(Color.red)
                            .cornerRadius(8)
                        }
                        .listRowBackground(Color.red) // Set the background color of the entire row
                    }
                    .frame(width: 360, height: 400)
                    .cornerRadius(20)
                }
                
                // Use Spacer to push the content to the top
                Spacer()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isDeviceConnected: .constant(false)) // Provide a mock binding
            .environmentObject(bluetooth_viewmodel()) // Provide a mock environment object
    }
}
