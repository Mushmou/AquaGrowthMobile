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
import FirebaseFirestore
import Firebase
import AuthenticationServices
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
    func signInWithGoogle() {
        /// Signs in user with credentials for Google Authentication
        ///
        ///- Parameters: None
        ///- Returns: None
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
                let userId = user.uid
                let userEmail = user.email
                self.insertUserRecord(id: userId, email: userEmail ?? "Empty Email")
            }
        }
    }
    
    private func insertUserRecord(id: String, email :String){
        /// This opens database and sets a record for user signing in with Google.
        ///
        ///- Parameters: None
        ///- Returns: None
        let newUser = User(id: id, username: "Google Username", email: email, password: "Google Password", signupDateTime: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
}


class signIn_Apple_viewModel: ObservableObject{
    func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
}
