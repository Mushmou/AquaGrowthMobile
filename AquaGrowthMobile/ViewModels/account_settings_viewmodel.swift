//
//  account_settings_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import FirebaseAuth

class account_settings_viewmodel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""

    init(){}
    
    func logOut(){
        ///  Signs out user in firebase authentication
        ///- Parameters: None
        ///- Returns: None
        do{
            try Auth.auth().signOut()
        }
        catch{
            print("File: profile_viewmodel, Error: ", error)
        }
    }
}
