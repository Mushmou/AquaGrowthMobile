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
    
    var body: some View {
        //We're experiencing a bug with navigation stack that
        //pushes view down, leading to rough transition.. However,
        //if we use the deprecated function navigation view
        //then it will smoothen the transitions.
        NavigationStack{
            VStack{
                ZStack{
                    //Set the green rectangle
                    Rectangle()
                        .fill(Color(red: 0.28, green: 0.59, blue: 0.17)) //Set the green color
                        .frame(width: UIScreen.main.bounds.width, height: 500) // Change the size of the VStack
                        .position(x: UIScreen.main.bounds.width / 2, y: 80) //Set the position (were using figma)
                    
                    Rectangle()
                        .fill(.white) //Set the white color
                        .frame(width: UIScreen.main.bounds.width, height: 640) // Change the size of the VStack
                        .position(x: UIScreen.main.bounds.width / 2, y: 550) //Set the position (were using figma)
                    
                    Text("Settings")
                        .font(.system(size: 50))
                        .bold()
                        .position(x: UIScreen.main.bounds.width / 2, y: 70)
                        .foregroundColor(.white)
                    
                    Form {
                        Section(header: Text("Global Settings")) {
                            NavigationLink {
                                BluetoothView()
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
                            
//                            NavigationLink {
//                                EditPlantView()
//                                    .toolbar(.hidden, for: .tabBar)
//
//                            } label: {
//                                Label("Help and Support", systemImage: "gearshape")
//                            }
                            NavigationLink {
                                TestView()
                                    .environmentObject(bluetooth)
                                    .toolbar(.hidden, for: .tabBar)

                            } label: {
                                Label("Test Data", systemImage: "gearshape")
                            }
                            
                        }
                        Section{
                            Button(action: {viewModel.logOut()}){
                                Text("Log Out").foregroundColor(.red)
                                }
                        }
                    
                    }
                    .frame(width: 360, height: 400) // Adjust the size of the List
                    .cornerRadius(20)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(bluetooth_viewmodel()) // Provide a mock environment object
}
