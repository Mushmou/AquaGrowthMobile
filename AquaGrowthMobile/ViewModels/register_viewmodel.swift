//
//  register_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import Foundation
import FirebaseAuth

class register_viewmodel: ObservableObject{
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirm_password = ""

    init(){}
}
