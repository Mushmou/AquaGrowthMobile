//
//  profile_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import FirebaseAuth
class profile_viewmodel: ObservableObject{
    init(){}

    func logOut(){
        do{
            try Auth.auth().signOut()
        }
        catch{
            print(error)
        }
    }
}
