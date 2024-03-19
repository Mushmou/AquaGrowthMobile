//
//  individual_plant_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class individualplant_viewmodel: ObservableObject{
    @Published var plant_id = ""
    @Published var led = 0
    @Published var moisture = 0
    @Published var humidity = 0
    @Published var fahrenheit = 0
    @Published var heatIndex = 0
    
    
    func SavedSensorInforamtion(){
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else{
            print("User not logged in")
            return
        }
        let id = UUID()
        db.collection("users")
            .document(uid)
            .collection("plants")
            .document(self.plant_id)
            .collection("sensors")
            .document(id.uuidString)
            .setData([
                "status" : led,
                "moisture": moisture,
                "humidity": humidity,
                "temperature" : fahrenheit,
                "heat": heatIndex,
                "record": Date().timeIntervalSince1970
            ],merge: true)
    }
}
