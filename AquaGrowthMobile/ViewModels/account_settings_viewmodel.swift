//
//  account_settings_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit

class account_settings_viewmodel: ObservableObject{
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var isPasswordValid = true
    @Published var isEmailValid = true
    @Published var isUsernameValid = true
    
    @Published var usernameError = ""
    @Published var emailError = ""
    @Published var passwordError = ""
    
    
    init(){
        getUserData()
    }
    
    func getUserData() {
        guard let user = Auth.auth().currentUser else {
            print("No user logged in")
            return
        }
        let uid = user.uid
        self.email = user.email ?? "None"
        
        let db = Firestore.firestore()
        let usersRef = db.collection("users")
        
        usersRef.document(uid).getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                if let foundUsername = document.data()?["username"] as? String {
                    self.username = foundUsername
                } else {
                    print("Username field not found or invalid type.")
                }
            } else {
                print("User document does not exist for UID: \(uid)")
            }
        }
    }
    
    func updateUserProfile() {
        guard let user = Auth.auth().currentUser else {
            print("No user logged in")
            return
        }
        
        let uid = user.uid
        let db = Firestore.firestore()
        let usersRef = db.collection("users").document(uid)
        
        var updateData: [String: Any] = [:]
        
        // Update username if it has been changed
        if !username.isEmpty {
            updateData["username"] = username
        }
        
        // Update email if it has been changed
        if !email.isEmpty {
            user.sendEmailVerification(beforeUpdatingEmail: email) { error in
                if let error = error {
                    print("Error updating email: \(error.localizedDescription)")
                    return
                }
            }
        }
        
        // Update password if it has been changed
        if !password.isEmpty {
            let credential = EmailAuthProvider.credential(withEmail: user.email!, password: password)
            // Reauthenticate user
            user.reauthenticate(with: credential) { result, error in
                if let error = error {
                    print("Error reauthenticating user: \(error.localizedDescription)")
                    return
                }
                
                // If reauthentication succeeds, update the password
                user.updatePassword(to: self.password) { error in
                    if let error = error {
                        print("Error updating password: \(error.localizedDescription)")
                        return
                    }
                }
            }
        }
            
        // Update the user document in Firestore
        usersRef.updateData(updateData) { error in
            if let error = error {
                print("Error updating user document: \(error.localizedDescription)")
                return
            }
            print("User profile updated successfully")
        }
    }
    
    func validateUser() -> Bool {
            // Rule 1: Only contains alphanumeric characters, underscore, and dot.
            let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._-")

            // Rule 2: Dot can't be at the end or start of a username.
            if username.hasPrefix(".") || username.hasSuffix(".") {
                usernameError = "Username can't start or end with a dot."
                isUsernameValid = false
                return false
            }

            // Rule 3: Dot and underscore can't be next to each other.
            if username.range(of: "._-") != nil {
                usernameError = "Username can't have dot/dash/underscore next to each other."
                isUsernameValid = false
                return false
            }

            // Rule 4: Dot can't be used multiple times in a row.
            if username.range(of: "..") != nil {
                usernameError = "Username can't have multiple dots in a row."
                isUsernameValid = false
                return false
            }

            // Rule 5: The username ends when there is a character other than the allowed characters.
            if let range = username.rangeOfCharacter(from: allowedCharacterSet.inverted) {
                usernameError = "Invalid character found in the username: \(username[range])"
                isUsernameValid = false
                return false
            }

            // Rule 6: Another username can only be written after a space.
            if username.contains(" ") {
                usernameError = "Username cannot include a space."
                isUsernameValid = false
                return false
            }

            // Additional rule: Minimum length requirement.
            if username.count < 4 {
                usernameError = "Username must be at least 4 characters long."
                isUsernameValid = false
                return false
            }

            // All validations passed.
            isUsernameValid = true
            return true
    }

    func validateEmail() -> Bool {
        let validCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-_!@#$%^&*")
            
        // Basic checks
        guard email.contains("@"), email.contains("."), let atIndex = email.firstIndex(of: "@"), let dotIndex = email.firstIndex(of: ".") else {
            emailError = "Invalid Email: Email must contain '@' and at least one '.'"
            isEmailValid = false
            return false
        }
            
        // Additional checks
        if atIndex != email.startIndex && atIndex != email.index(before: email.endIndex) {
            if dotIndex != email.startIndex && dotIndex != email.index(before: email.endIndex) {
                if email.rangeOfCharacter(from: validCharacterSet.inverted) == nil {
                    if email.range(of: "..") == nil {
                        let domain = String(email.suffix(from: dotIndex))
                        if domain.contains(".") && domain.count >= 3 {
                            isEmailValid = true
                            return true
                        } else {
                            emailError = "Invalid Email: Invalid domain."
                        }
                    } else {
                        emailError = "Invalid Email: Consecutive dots are not allowed."
                    }
                } else {
                    emailError = "Invalid Email: Contains invalid characters."
                }
            } else {
                emailError = "Invalid Email: At least one character is required before and after the dot."
            }
        } else {
            emailError = "Invalid Email: '@' cannot be the first or last character."
        }
            
        // Email requirements not met
        isEmailValid = false
        return false
    }
        
    func validatePassword() -> Bool {
        // Common password requirements
        let minLength = 6
        let containsUpperCase = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
        let containsLowerCase = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*")
        let containsDigit = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")

        // Check if passwords match and meet the minimum length requirement
        if password == confirmPassword && password.count >= minLength {
            // Check additional password requirements
            if containsUpperCase.evaluate(with: password) {
                if containsLowerCase.evaluate(with: password) {
                    if containsDigit.evaluate(with: password) {
                        // All password requirements passed
                        isPasswordValid = true
                        return true
                    } else {
                        passwordError = "Password must contain at least one digit."
                    }
                } else {
                    passwordError = "Password must contain at least one lowercase letter."
                }
            } else {
                passwordError = "Password must contain at least one uppercase letter."
            }
        } else {
            passwordError = "Passwords do not match or are too short."
        }

        // Password requirements not met
        isPasswordValid = false
        return false
    }
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
