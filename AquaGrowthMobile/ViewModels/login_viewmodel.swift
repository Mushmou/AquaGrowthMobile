//
//  login_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//  Edited by Noah Jacinto on 3/1/24.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore

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

class signIn_google_viewModel: ObservableObject{
    @Published var isLoginSuccess = false
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            
            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString else {
                return
            }
            
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) {res, error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                guard let user = res?.user else{
                    return
                }
                print(user)
            }
            
        }
    }
}
