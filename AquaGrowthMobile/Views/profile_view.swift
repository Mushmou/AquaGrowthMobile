//
//  profile_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI
    
struct ProfileView: View {
    @StateObject var viewModel = profile_viewmodel()
    var body: some View {
        
        VStack{
            Text("Profile View")
                .padding(10)
            Button("Logout"){
                viewModel.logOut()
            }
        }
    }
}

#Preview {
    ProfileView()
}
