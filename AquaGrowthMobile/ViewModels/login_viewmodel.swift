//
//  login_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//  Edited by Noah Jacinto on 3/1/24.
//

import Foundation
import FirebaseAuth

class login_viewmodel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    
    init(){}
    
    func login(){
        /// Signs in user with Email and Password in Firebase Authentication.
        ///
        ///- Parameters: None
        ///- Returns: None
        guard validate() else {
                    return
                }

                isLoading = true  // Start loading
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                    DispatchQueue.main.async {
                        self?.isLoading = false  // Stop loading when login completes

                        if let error = error {
                            self?.errorMessage = error.localizedDescription
                        } else if result?.user != nil {
                            // Handle successful login
                        } else {
                            self?.errorMessage = "An unknown error occurred"
                        }
                    }
                }
    }
    
    private func validate() -> Bool{
        /// Validates the inputs before signing in.
        ///
        ///- Parameters: None
        ///- Returns: A Boolean Value whether or not all validations are correct.
        errorMessage = ""
        
        
        //Check if email or password is NOT empty.
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else{
            errorMessage = "Please fill in all fields."
            return false
        }
        
        //Ensures email has @ or periods.
        guard email.contains("@") && email.contains(".") else{
            errorMessage = "Please enter valid email."
            return false
        }
        
        return true
    }
    
}
