//
//  individual_plant_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class individualplant_viewmodel: ObservableObject {
    @Published var plant_id = ""
    @Published var led = 0
    @Published var moisture = 0
    @Published var humidity = 0
    @Published var fahrenheit = 0
    @Published var heatIndex = 0
    @Published var currentDay = ""
    
    init(){
        
        self.currentDay = formatDate(Date(), format:  "yyyy-MM-dd")
    }
    
    func SavedSensorInformation() {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let sensorData = [
            "status": led,
            "moisture": moisture,
            "humidity": humidity,
            "temperature": fahrenheit,
            "heat": heatIndex,
            "timestamp": Date().timeIntervalSince1970
        ] as [String : Any]

        let currentDate = Date()
        let dailyId = formatDate(currentDate, format: "yyyy-MM-dd")
        let weeklyId = formatDate(currentDate, format: "yyyy-'W'ww")
        let monthlyId = formatDate(currentDate, format: "yyyy-MM")
        
        // Call the updated addSensorData method
        addSensorData(db: db, userId: uid, collection: "daily", documentId: dailyId, data: sensorData)
        addSensorData(db: db, userId: uid, collection: "weekly", documentId: weeklyId, data: sensorData)
        addSensorData(db: db, userId: uid, collection: "monthly", documentId: monthlyId, data: sensorData)
    }
    
    func updateLastSensorData(db: Firestore, userId: String, collection: String, data: [String: Any]) {
        let documentRef = db.collection("users")
            .document(userId)
            .collection("plants")
            .document(self.plant_id)
            .collection(collection)
            .document("last")
            
        documentRef.updateData(["readings": [data]])
        { err in
            if let err = err {
                // If the document does not exist, create a new one
                documentRef.setData(["readings" : data])
                print("Error - \(err) Occured Saving to FireBase")
            }
        }
    }
    
    func addSensorData(db: Firestore, userId: String, collection: String, documentId: String, data: [String: Any]) {
        let plantCollectionRef = db.collection("users")
            .document(userId)
            .collection("plants")
            .document(self.plant_id)
            .collection(collection)
            .document(documentId)
        
        // Iterate over each key-value pair in the data dictionary
        for (key, value) in data {
            let sensorDataRef = plantCollectionRef.collection(key)
            // Each sensor's data is stored in its own document, named by the key
            let sensorData = sensorDataRef.document(UUID().uuidString)
            // Assuming all data values are of a type that can be directly stored in Firestore
            sensorData.setData([key: value]) { error in
                if let error = error {
                    print("Error adding data for \(key): \(error)")
                } else {
                    print("Successfully added data for \(key)")
                }
            }
        }
    }

    
    // Helper function to format dates
    func formatDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func fetchLatestDailyData() {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }

        // Reference to 'last' document within the 'plants' collection
        let lastDocumentRef = db.collection("users")
            .document(uid)
            .collection("plants")
            .document(self.plant_id)
            .collection("last") // Changed from 'daily' to 'last'
            .document("last") // Changed from 'self.currentDay' to 'last'

        lastDocumentRef.getDocument { [weak self] (documentSnapshot, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else if let document = documentSnapshot, document.exists {
                guard let data = document.data(), let readings = data["readings"] as? [[String: Any]] else {
                    print("Document does not have a 'readings' array")
                    return
                }

                // Get the first reading from the 'readings' array
                if let firstReading = readings.first {
                    DispatchQueue.main.async {
                        self?.updatePlantParameters(with: firstReading)
                    }
                } else {
                    print("Readings array is empty")
                }
            }
        }
    }

    private func updatePlantParameters(with data: [String: Any]) {
            self.led = data["status"] as? Int ?? self.led
            self.moisture = data["moisture"] as? Int ?? self.moisture
            self.humidity = data["humidity"] as? Int ?? self.humidity
            self.fahrenheit = data["temperature"] as? Int ?? self.fahrenheit
            self.heatIndex = data["heat"] as? Int ?? self.heatIndex
            
            print(self.led)
            print(self.moisture)
            print(self.humidity)
            print(self.fahrenheit)
            print(self.heatIndex)
        
    }
}
