//
//  ContentView.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/19/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingSplashScreen = true

    var body: some View {
        Group {
            if isShowingSplashScreen {
                SplashScreenView()
                    .transition(.move(edge: .top))
            } else {
                MainView()
            }
        }
        .onAppear {
            performDelayedSplashScreenHide()
        }
    }

    private func performDelayedSplashScreenHide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.35) {
            withAnimation {
                self.isShowingSplashScreen = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SplashScreenView : View {
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            SplashScreen(filename: "Splash_screen")
        }
        .transition(.move(edge: .top)) // Added transition here too
    }
}
