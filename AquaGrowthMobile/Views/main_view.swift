//
//  main_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//  Edited by Noah Jacinto 3/9/24

import Foundation
import SwiftUI

struct MainView: View {
    var bluetooth = bluetooth_viewmodel()
    @StateObject var viewModel = main_viewmodel()
    @State var isDeviceConnected = false // State to track device connection

    var body: some View {
        //Check if the user is signed in (Through firebase Authentication)
        if viewModel.isSignedIn {
            //Tab view for the three main pages (Home, Plant, and Settings)
            TabView {
                HomeView()
                    .environmentObject(bluetooth)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                PlantView()
                    .environmentObject(bluetooth)
                    .tabItem {
                        Label("Plant", systemImage: "leaf")
                    }
                    .environmentObject(bluetooth)
                SettingsView(isDeviceConnected: $isDeviceConnected)
                    .environmentObject(bluetooth)
                    .tabItem {
                        Label("Account", systemImage: "person.crop.circle.fill")
                    }
            }
            .accentColor(isDeviceConnected ? .green : nil) // Change tab color if device is connected

//            .onChange(of: isDeviceConnected) { connected in
//                .accentColor(isDeviceConnected ? .green : nil) // Change tab color if device is connected
//            }
        } else {
            LoginView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
