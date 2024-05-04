import Firebase
import Foundation

import FirebaseFirestore
import FirebaseAuth

class home_viewmodel: ObservableObject {
    @Published var favoritePlants = [Plant]()
    @Published var favoritePlantUUIDs = [String]() // Store UUIDs of favorite plants
    @Published var humidity_average: [String: Double] = [:]
    @Published var temperature_average: [String: Double] = [:]
    @Published var light_average: [String: Double] = [:]


    func fetchFavoritePlants() {
        let db = Firestore.firestore()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        db.collection("users")
            .document(uid)
            .collection("plants")
            .whereField("favorite", isEqualTo: 1) // Filter only favorite plants
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting favorite plants: \(error)")
                } else {
                    self.favoritePlants = querySnapshot?.documents.compactMap { document in
                        let data = document.data()
                        let plantID = document.documentID
                        let plantName = data["plant_name"] as? String ?? ""
                        let plantType = data["plant_type"] as? String ?? ""
                        let plantDescription = data["plant_description"] as? String ?? ""
                        let plantImage = data["plant_image"] as? String ?? ""
                        
                        // Add UUID to the array
                        self.favoritePlantUUIDs.append(plantID)
                        return Plant(id: UUID(uuidString: plantID) ?? UUID(),
                                     plant_name: plantName,
                                     plant_type: plantType,
                                     plant_description: plantDescription,
                                     plant_image: plantImage)
                    } ?? []
                }
            }
    }
    
    func getHumidityImage(plantId: String) -> String {
        let humidity = self.humidity_average[plantId] ?? 0
         
         if humidity < 45 {
             return "humidity_100"
         } else if humidity < 50 {
             return "humidity_75"
         } else if humidity < 55 {
             return "humidity_50"
         } else if humidity < 60 {
             return "humidity_25"
         } else {
             return "humidity_original"
         }
    }
    
    func getTemperatureImage(plantId: String) -> String {
        let temperature = self.temperature_average[plantId] ?? 0
         if temperature < 45 {
             return "temperature_100"
         } else if temperature < 55 {
             return "temperature_75"
         } else if temperature < 65 {
             return "temperature_50"
         } else if temperature < 70 {
             return "temperature_25"
         } else {
             return "temperature_original"
         }
    }
    
    func getLightImage(plantId: String) -> String {
        let my_light = self.light_average[plantId] ?? 0
         if my_light < 80 {
             return "sun_100"
         } else if my_light < 90 {
             return "sun_75"
         } else if my_light < 100 {
             return "sun_50"
         } else if my_light < 120 {
             return "sun_25"
         } else {
             return "sun_original"
         }
    }
    func fetchMostRecentDocumentForAllPlants(sensor: String) {
        
        let currentDate = Date() + 1 // Assuming you're adding one day to the current date
        let weeklyId = formatDate(currentDate, format: "yyyy-'W'ww")
        let monthlyId = formatDate(currentDate, format: "yyyy-MM")

        print(weeklyId)
        print(monthlyId)
        
        let db = Firestore.firestore()
        let dispatchGroup = DispatchGroup()
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        var averages: [String: Double] = [:] // Dictionary to store plant_id and average sensor reading
        
        for plant in favoritePlants {
            dispatchGroup.enter() // Enter the group before each async operation
            
            let plantId = plant.id.uuidString
            
            let documentRef = db.collection("users")
                .document(uid)
                .collection("plants")
                .document(plantId)
                .collection("monthly")
                .document(monthlyId)
                .collection(weeklyId)
                .order(by: "timestamp", descending: true)
                .limit(to: 7)
            
            var weeklyAverage: Int = 0
            var totalDays: Int = 0
            
            documentRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    dispatchGroup.leave()
                    return
                }
                
                let dispatchGroupInner = DispatchGroup() // Inner group to handle nested asynchronous calls
                
                for document in querySnapshot!.documents {
                    dispatchGroupInner.enter() // Enter inner group before each async operation
                    
                    let secondRef = document.reference // Get reference to the document
                        .collection(sensor)
                    
                    secondRef.getDocuments { (secondSnapshot, anotherError) in
                        if let error = anotherError {
                            print("Error getting documents: \(error)")
                            dispatchGroupInner.leave() // Leave inner group if there's an error
                            return
                        }
                        
                        var dailySensorValue: Int = 0
                        var count: Int = 0
        
                        for secondDocument in secondSnapshot!.documents {
                            if let value = secondDocument.data()[sensor] as? Int {
                                
                                if value > 0{
                                    dailySensorValue += value
                                    count += 1
                                }
                            }
                        }
                        
                        let average = count > 0 ? dailySensorValue / count : 0
                        
                        if average > 0{
                            weeklyAverage += average
                            totalDays += 1

                        }
                        dispatchGroupInner.leave() // Leave inner group after processing each document
                    }
                }
                
                dispatchGroupInner.notify(queue: .main) {
                    // Calculate the average after all inner asynchronous calls are finished
                    if totalDays > 0 {
                        let average = Double(weeklyAverage) / Double(totalDays)
                        averages[plantId] = average
                    } else {
                        averages[plantId] = 0 // No data found, set average to 0
                    }
                    
                    dispatchGroup.leave() // Leave outer group after processing all documents
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // All asynchronous tasks are finished
            // Now you can use averages dictionary containing plant_id and corresponding average sensor reading
            print("Averages:", averages, sensor)
            
            if (sensor) == "temperature"{
                self.temperature_average = averages
            }
            else if (sensor) == "light"{
                self.light_average = averages
            }
            else if (sensor) == "humidity"{
                self.humidity_average = averages
            }
        }
    }
    
    // Helper function to format dates
    func formatDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

