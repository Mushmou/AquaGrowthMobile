//
//  home_info_view.swift
//  AquaGrowthMobile


import Foundation
import SwiftUI

struct HomeInfoView: View {
    @StateObject var viewModel = plant_viewmodel()

    var body: some View {
        Text("Test")

        List {
            ForEach(viewModel.plants) { plant in
                Text(plant.plant_name) // You can customize the appearance as needed
            }
        }
    }
}

struct HomeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock plant_viewmodel instance
        let mockViewModel = plant_viewmodel()
        
        // Pass the mockViewModel to HomeInfoView
        HomeInfoView(viewModel: mockViewModel)
    }
}
