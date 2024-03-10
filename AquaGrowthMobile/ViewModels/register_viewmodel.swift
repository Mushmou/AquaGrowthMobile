//
//  register_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//  Edited by Noah Jacinto on 3/1/24
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class register_viewmodel: ObservableObject{
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirm_password = ""
    
    @Published var isPasswordValid = true
    @Published var isEmailValid = true
    @Published var isUsernameValid = true
    
    @Published var usernameError = ""
    @Published var emailError = ""
    @Published var passwordError = ""
    
    init(){}
    
    
    func register(){
        ///  Registers a new user with Email and Password in Firebase Auth.
        ///- Parameters: None
        ///- Returns: None
    
        //Validate function should run all other validations as well... im lazy okay?
        guard (validate()) else{
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle error
                print("Error creating user:", error.localizedDescription)
                return
            }
            
            // User successfully created
            if let authResult = authResult {
                // Handle successful creation
                print("File: register_viewmodel, Message: Registered account with", authResult.user.uid)
            }
            
            guard let userId = authResult?.user.uid else{
                return
            }
            self.insertUserRecord(id: userId)
        }
    }
    
    
    private func insertUserRecord(id: String){
        let newUser = User(id: id, username: username, email: email, password: password, signupDateTime: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
        
    }
    
    func validateUser() -> Bool{
        /// Validates the Usersname textfield on submission.
        /// Edited by Noah Jacinto 3/1/24
        ///
        /// Notes (TODO):
        /// 1. Only contains alphanumeric characters, underscore and dot.
        /// 2. Dot can't be at the end or start of a username (e.g .username / username.)
        /// 3. Dot and underscore can't be next to each other (e.g user_.name)
        /// 4. Dot can't be used multiple times in a row (e.g. user..name)
        /// 5. The username ends when there is a character other than the allowed characters (e.g. @user@next or @user/nnnn would only validate user as a valid username)
        /// 6.  Another username can only be written after a space. (e.g. @user @next would validate two usernames while @user@next would only validate user)
        ///
        ///- Parameters: None
        ///- Returns: A Boolean Value whether or not all validations are correct.
        if username.count >= 4 {
            isUsernameValid = true
        }
        else{
            usernameError = "Username Error"
            isUsernameValid = false
            return false
        }
        return true
    }
    
    func validateEmail() -> Bool{
        /// Validates the Email  textfield on submission.
        ///
        /// Notes (TODO):
        /// 1. Checks if email contains "@" symbol
        /// 2. Checks if email contains at least one "."
        ///- Parameters: None
        ///- Returns: A Boolean Value whether or not all validations are correct.
        if email.contains("@") && email.contains("."){
            isEmailValid = true
        }
        else{
            emailError = "Email Error"
            isEmailValid = false
            return false
        }
        return true
    }
    
    func validatePassword() -> Bool{
        /// Validates the Password  securefield  on submission.
        ///
        /// Notes (TODO):
        /// 1. Checks if email contains "@" symbol
        /// 2. Checks if email contains at least one "."
        ///- Parameters: None
        ///- Returns: A Boolean Value whether or not all validations are correct.
        if password == confirm_password && password.count >= 6 {
            isPasswordValid = true
        }
        else{
            passwordError = "Password Error"
            isPasswordValid = false
            return false
        }
        return true
    }
    
    private func validate() -> Bool{
        /// General Validation after Create Account  button is pressed.
        ///
        ///- Parameters: None
        ///- Returns: A Boolean Value whether or not all validations are correct.
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty
        else{
            isUsernameValid = false
            isEmailValid = false
            isPasswordValid = false
            return false
        }
        
        guard validateUser()
                else
        {
            return false
        }
        
        guard validateEmail()
        else{
            return false
        }
        
        guard validatePassword()
        else{
            return false
        }
        
        return true
    }
}
