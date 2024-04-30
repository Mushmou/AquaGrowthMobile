//
//  account_settings_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class account_settings_viewmodel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""

    init(){}
    
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
    
    func getUserEmail(){
        let user = Auth.auth().currentUser
        
        let uid = user?.uid
        self.email = user?.email ?? "None"
    }
    
    func getUsername() {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        
        let db = Firestore.firestore()

        // Reference to the "users" collection
        let usersRef = db.collection("users")
        
        print(usersRef)
        // Query for the user document with the specified UID
        usersRef.document(uid ?? "None").getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error)")
                return
            }
            
            if let document = document, document.exists {
                // If document exists, retrieve the "username" field
                if let foundUsername = document.data()?["username"] as? String {
                    // Assign the retrieved username to the username property
                    self.username = foundUsername ?? "None"
                } else {
                    // If "username" field is missing or not a string
                    print("Username field not found or invalid type.")
                }
            } else {
                // Document does not exist or user not found
                print("User document does not exist for UID: \(uid)")
            }
        }
    }
}
