//
//  temp.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 3/9/24.
//

import Foundation
import SwiftUI

struct TempView: View {
    @StateObject var viewModel = settings_viewmodel()

    var body: some View {
        NavigationView {
            List{
                NavigationLink {
                    BluetoothView()
                        .navigationBarBackButtonHidden(true)
                }label :{
                    Image(systemName: "house")
                }
            }
//            List {
//                Section(header: Text("Global Settings")) {
//                    NavigationLink("Bluetooth Settings", destination: BluetoothView())
//                    NavigationLink("Account Settings", destination: AccountView())
//                        .navigationBarBackButtonHidden(true)
//                }
//            }
        }
    }
}

#Preview{
    TempView()
}
