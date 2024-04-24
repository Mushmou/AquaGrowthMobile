//
//  home_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//
import Firebase
import Foundation

import FirebaseFirestore
import FirebaseAuth

class home_viewmodel: ObservableObject{
    init(){}

    func test(){
        print("hi")
    }
    func top_three(){
        print("hello")
        //Setup DB
        let db = Firestore.firestore()
        
        //Grab the current user id
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        db.collection("users")
            .document(uid)
            .collection("plants")
            .order(by: "plant_id") // Specify the field you want to order the documents by
            .limit(to: 3)
            .getDocuments(completion: { (querySnapshot, error) in
                if let error = error {
                    // Handle the error
                    print("Error getting documents: \(error)")
                } 
                else {
                    guard let documents = querySnapshot?.documents else {
                        print("No documents found.")
                        return
                    }
                    
                    // Iterate through the documents
                    for document in documents {
                        let data = document.data()
                        // Do something with the document data
                        print(data)
                        print(data.keys)
                        print(data["plant_id"] ?? "")
                        print(data["plant_name"] ?? "")
                        print(data["plant_image"] ?? "")
                        print(data["plant_type"] ?? "")
                        print(data["plant_description"] ?? "")
                    }
                }
            })
        
    }
}
