//
//  profile_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import FirebaseAuth
class settings_viewmodel: ObservableObject{
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
