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
    @State private var showNavigationBar = true

    var body: some View {
        NavigationStack{
            VStack{
                ZStack{
                    Rectangle()
                        .fill(Color(red: 0.28, green: 0.59, blue: 0.17))
                        .frame(width: UIScreen.main.bounds.width, height: 500) // Change the size of the VStack
                        .position(x: UIScreen.main.bounds.width / 2, y: 80)
                    
                    Rectangle()
                        .fill(.white)
                        .frame(width: UIScreen.main.bounds.width, height: 640) // Change the size of the VStack
                        .position(x: UIScreen.main.bounds.width / 2, y: 550)
                    
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
                            
                            NavigationLink {
                                EmptyView()
                                    .toolbar(.hidden, for: .tabBar)

                            } label: {
                                Label("Help and Support", systemImage: "gearshape")
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
}
