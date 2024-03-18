//
//  plant_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Plant: Identifiable {
    var id = UUID()
    var plant_name: String
    var plant_type: String
    var plant_description: String
    var plant_image: String // This should be a string referring to the image name
}

class plant_viewmodel: ObservableObject{
    @Published var plants = [
        Plant(plant_name: "Fern", plant_type: "something what", plant_description: "I love ferns", plant_image: "Tomato"),
        Plant(plant_name: "Cactus", plant_type: "pincushion", plant_description: "Yea its a prickly cactus", plant_image: "Temperature"),
        Plant(plant_name: "Orchid", plant_type: "colorful flower", plant_description: "Colorful and stuff", plant_image: "Water"),
    ]
    
    
    func savePlant(_ plant: Plant) {
        plants.append(plant)
    }
    
    func savePlantDatabase(_ plant: Plant){
        let db = Firestore.firestore()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        db.collection("users").document(uid).collection("plants").addDocument(data: [
            "plant_name": plant.plant_name,
            "plant_type": plant.plant_type,
            "plant_description": plant.plant_description,
            "plant_image": plant.plant_image
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
    }
    
    func fetchPlants() async {

//        let db = Firestore.firestore()
//        
//        guard let uid = Auth.auth().currentUser?.uid else {
//            print("User not logged in")
//            return
//        }
//        
//        do {
//            let querySnapshot = try await db.collection("plants").getDocuments()
//          for document in querySnapshot.documents {
//            print("\(document.documentID) => \(document.data())")
//          }
//        } catch {
//          print("Error getting documents: \(error)")
//        }
    }
}
