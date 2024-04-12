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
        
        // Current date as String for document ID
        let currentDate = Date()
        
        //        let daysToAdd = 30
        //        // Get the Calendar
        //        let calendar = Calendar.current
        //        // Add the days
        //        let newDate = calendar.date(byAdding: .day, value: daysToAdd, to: currentDate) ?? currentDate
        
        let dailyId = formatDate(currentDate, format: "yyyy-MM-dd")
        let weeklyId = formatDate(currentDate, format: "yyyy-'W'ww")
        let monthlyId = formatDate(currentDate, format: "yyyy-MM")
        
        
        // Save data for daily, weekly, monthly collections
        updateSensorData(db: db, userId: uid, collection: "daily", documentId: dailyId, data: sensorData)
        updateSensorData(db: db, userId: uid, collection: "weekly", documentId: weeklyId, data: sensorData)
        updateSensorData(db: db, userId: uid, collection: "monthly", documentId: monthlyId, data: sensorData)
    }
    
    func updateSensorData(db: Firestore, userId: String, collection: String, documentId: String, data: [String: Any]) {
        let documentRef = db.collection("users").document(userId)
            .collection("plants").document(self.plant_id)
            .collection(collection).document(documentId)
        
        documentRef.updateData([
            "readings": FieldValue.arrayUnion([data])
            
        ]) { err in
            if let err = err {
                // If the document does not exist, create a new one
                documentRef.setData(["readings": [data]])
                print("Error - \(err) Occured Saving to FireBase")
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
        
        let collectionRef = db.collection("users").document(uid)
            .collection("plants").document(self.plant_id)
            .collection("daily")
        
        collectionRef.order(by: "timestamp", descending: true).limit(to: 1)
            .getDocuments { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    // Assuming the data structure includes an array of readings under 'readings'
                    if let document = querySnapshot?.documents.first,
                       let readings = document.data()["readings"] as? [[String: Any]],
                       let latestReading = readings.last {
                        self?.updatePlantParameters(with: latestReading)
                    }
                }
            }
    }
    private func updatePlantParameters(with data: [String: Any]) {
        DispatchQueue.main.async {
            self.led = data["status"] as? Int ?? self.led
            self.moisture = data["moisture"] as? Int ?? self.moisture
            self.humidity = data["humidity"] as? Int ?? self.humidity
            self.fahrenheit = data["temperature"] as? Int ?? self.fahrenheit
            self.heatIndex = data["heat"] as? Int ?? self.heatIndex
        }
    }
}
