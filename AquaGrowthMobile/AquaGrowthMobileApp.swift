//
//  AquaGrowthMobileApp.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/19/24.
//
import FirebaseCore
import SwiftUI

@main
struct AquaGrowthMobileApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
            ContectView()
        }
    }
}
