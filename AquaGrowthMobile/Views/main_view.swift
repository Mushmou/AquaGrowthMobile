//
//  main_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI

struct MainView: View {
    @StateObject var viewModel = main_viewmodel()
    var body: some View {
        if viewModel.isSignedIn{
            TabView{
                HomeView().tabItem {
                    Label("Home", systemImage: "house")
                }
                PlantView().tabItem{
                    Label("Plant", systemImage: "leaf")
                }
                SettingsView().tabItem{
                    Label("User", systemImage: "person.crop.circle.fill")
                }
            }
        }
        else{
            LoginView()
        }
    }
}

#Preview {
    MainView()
}
