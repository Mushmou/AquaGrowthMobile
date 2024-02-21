//
//  login_view_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/21/24.
//

import Foundation


class LoginViewViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init(){}
    
    func login(){
        print("Doing some login")
    }
}

