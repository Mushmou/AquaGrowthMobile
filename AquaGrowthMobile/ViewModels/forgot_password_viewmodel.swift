//
//  forgot_password_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import FirebaseAuth
class forgot_password_viewmodel: ObservableObject{
    @Published var email = ""
    init(){}
    
    func reset(){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
          // ...
        }
    }
}
