//
//  main_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import FirebaseAuth

class UserData: ObservableObject {
    @Published var user = User(id: "userID", username: "username", email: "email@example.com", password: "password", signupDateTime: Date().timeIntervalSince1970)
}
class main_viewmodel: ObservableObject{
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async{
                self?.currentUserId = user?.uid ?? ""
            }
        }
    }
    
    public var isSignedIn: Bool{
        ///  Checks if the user is signed in.
        ///- Parameters: None
        ///- Returns: Returns Boolean value whether or not user is signed in to main view.
        return Auth.auth().currentUser != nil
    }
}
