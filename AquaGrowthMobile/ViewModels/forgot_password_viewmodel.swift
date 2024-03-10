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
        ///  Sends password  reset email. This creates the password reset email 
        ///- Parameters: None
        ///- Returns: None
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // Handle error
                print("File: forgot_password_viewmodel, Message: Error creating user:", error.localizedDescription)
                return
            }
            else{
                print("File: forgot_password_viewmodel, Message: Sent email reset to user")
            }
        }
    }
}