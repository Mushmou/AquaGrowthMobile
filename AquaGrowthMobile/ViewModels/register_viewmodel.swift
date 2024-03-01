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
    @Published var isPasswordValid = true
    @Published var isEmailValid = true
    @Published var isUsernameValid = true

    init(){}
    
    // Basic Login Functionality
    
    func run(){
        print("running")
    }
    func register(){
        guard validate() else{
            print("Failed Register Validation")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          // Perform something here?
        }
        print("Registered")
        print("username")
    }
    
    //We need to implement a validation before logging in. Maybe some simple error checking
    private func validate() -> Bool{
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else{
            return false
        }
        
        guard username.count >= 4 else{
            isUsernameValid = false
            return false
        }
        guard password == confirm_password else{
            isPasswordValid = false
            return false
        }
        
        guard email.contains("@") && email.contains(".") else{
            isEmailValid = false
            return false
        }
        
        guard password.count >= 6 else{
            return false //password size
        }
        
        return true
    }
}
