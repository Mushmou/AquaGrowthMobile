//
//  account_settings_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI

struct AccountView: View {
    @StateObject var viewModel = account_settings_viewmodel()
    @State var notifyMeAbout = ""
    @State var NotifyMeAboutType = ""
    @State private var showNavigationBar = true
    @State var playNotifications = false
    @State var sendReadReceipt = false
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink("Bluetooth Settings"){
                        BluetoothView()
                            .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
    }
}

#Preview{
    AccountView()
}
