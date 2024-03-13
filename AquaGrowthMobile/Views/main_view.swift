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
 
    var body: some View {
        //Check if the user is signed in (Through firebase Authentication)
        if viewModel.isSignedIn{
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                PlantView()
                    .tabItem {
                        Label("Plant", systemImage: "leaf")
                    }
                SettingsView().environmentObject(bluetooth)
                    .tabItem {
                        Label("Account", systemImage: "person.crop.circle.fill")
                    }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        else{
            LoginView()
        }
    }
}

#Preview {
    MainView()
}
