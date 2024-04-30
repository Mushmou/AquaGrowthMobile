//
//  change_password_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//  Edited by Noah Jacinto on 3/1/24.
//

import Foundation
import FirebaseAuth

class change_password_viewmodel: ObservableObject{
    @Published var email = ""
    init(){}
    
    func reset(){
        /// Resets the password through Email. This "Resends the Password Reset Email"
        ///
        ///- Parameters: None
        ///- Returns: None
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // Handle error
                print("File: changed_password_viewmodel, Message: Error creating user:", error.localizedDescription)
                return
            }
            else{
                print("File: changed_password_viewmodel, Message: Sent email reset to user")
            }
        }
    }
}
