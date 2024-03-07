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
            TabView {
                HomeView()
                    .badge(2)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                PlantView()
                    .tabItem {
                        Label("Plant", systemImage: "leaf")
                    }
                SettingsView()
                    .badge("!")
                    .tabItem {
                        Label("Account", systemImage: "pserson.crop.circle.fill")
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

//            ZStack {
//                VStack {
//                    TabView(selection: $tabSelected) {
//                        ForEach(Tab.allCases, id: \.rawValue) { tab in
//                            HStack {
//                                if (tab.rawValue  == "house"){
//                                    HomeView()
//                                }
//                                else if (tab.rawValue == "message"){
//                                    SettingsView()
//                                }
//                            }
//                            .tag(tab)
//                        }
//                    }
//                }
//                VStack {
//                    Spacer()
//                    CustomTabBar(selectedTab: $tabSelected)
//                }
//            }

//            TabView{
//                HomeView().tabItem {
//                    Label("Home", systemImage: "house")
//                }
//                PlantView().tabItem{
//                    Label("Plant", systemImage: "leaf")
//                }
//                SettingsView().tabItem{
//                    Label("User", systemImage: "person.crop.circle.fill")
//                        .toolbar(.hidden, for: .tabBar)
//                }
//            }

//            NavigationStack{
//                ZStack{
//                    HStack{
//                        NavigationLink{
//                            HomeView()
//                                .navigationBarBackButtonHidden(true)
//                        }label: {
//                            Label("", systemImage: "house")
//                                .padding([.trailing, .leading], 40)
//
//                        }
//                        .border(.red)
//
//                        NavigationLink{
//                            PlantView()
//                                .navigationBarBackButtonHidden(true)
//                        }label: {
//                            Label("", systemImage: "leaf")
//                                .padding([.trailing, .leading], 40)
//                        }
//                        .border(.red)
//
//                        NavigationLink{
//                            SettingsView()
//                                .navigationBarBackButtonHidden(true)
//
//                        }label: {
//                            Label("", systemImage: "person.crop.circle.fill")
//                                .padding([.trailing, .leading], 40)
//
//                        }
//                        .border(.red)
//                    }
//                }
//            }
            
