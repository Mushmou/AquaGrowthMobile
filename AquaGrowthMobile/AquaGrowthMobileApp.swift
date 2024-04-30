//
//  AquaGrowthMobileApp.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/19/24.
//
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI
import CryptoKit

//https://aquagrowth-21b0c.firebaseapp.com/__/auth/handler

@main
struct AquaGrowthMobileApp: App {
    
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    init(){
//        FirebaseApp.configure()
//    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      // [START firebase_configure]
      // Use Firebase library to configure APIs
      FirebaseApp.configure()
      // [END firebase_configure]
      return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
    
}
