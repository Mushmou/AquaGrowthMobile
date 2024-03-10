//
//  plant_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation

struct Plant: Identifiable {
    var id = UUID()
    var plant_name: String
    var plant_type: String
    var plant_description: String
    var plant_image: String // This should be a string referring to the image name
}

//class PlantManager: ObservableObject{
//    @Published var plants = [Plant]
//    
//}
