//
//  profile_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI
    
struct SettingsView: View {
    @StateObject var viewModel = settings_viewmodel()
    init() {
        // Make the navigation bar transparent
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    var body: some View {
        NavigationStack{
            ZStack{
                Rectangle()
                    .fill(Color(red: 0.28, green: 0.59, blue: 0.17))
                    .frame(width: 400, height: 300) // Change the size of the VStack
                    .position(x: UIScreen.main.bounds.width / 2, y: 80)
                
                Rectangle()
                    .fill(.white)
                    .frame(width: 400, height: 640) // Change the size of the VStack
                    .position(x: UIScreen.main.bounds.width / 2, y: 550)
                
                Text("Settings")
                    .font(.system(size: 50))
                    .bold()
                    .position(x: UIScreen.main.bounds.width / 2, y: 70)
                    .foregroundColor(.white)
                
                VStack {
                    List {
                        NavigationLink(destination: BluetoothView()) {
                            Text("Bluetooth Devices")
                                .bold()
                        }
                        
                        NavigationLink(destination: ProfileView()) {
                            Text("Profile Settings")
                                .bold()
                        }
                        NavigationLink(destination: EmptyView()) {
                            Text("Help and Support")
                                .bold()
                        }
                    }
                    .border(.red)
                    .background(.white)
                    .frame(width: 360, height: 200) // Adjust the size of the List
                    .listStyle(PlainListStyle()) // Apply GroupedListStyle
                }
                .cornerRadius(20)
                
                
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: 300, height: 65)
                    .foregroundColor(.red)
                    .overlay(
                        Button("Logout?") {
                            viewModel.logOut()
                        }
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    )
                    .position(x: UIScreen.main.bounds.width / 2, y: 700)
            }
            .navigationTitle("")
            .navigationBarHidden(true) // Hide the navigation bar
        }
    }
}

#Preview {
    SettingsView()
}
