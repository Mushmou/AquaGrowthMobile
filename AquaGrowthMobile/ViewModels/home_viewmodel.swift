
import Firebase
import Foundation

import FirebaseFirestore
import FirebaseAuth

class home_viewmodel: ObservableObject {
    @Published var favoritePlants = [Plant]()
    @Published var favoritePlantUUIDs = [String]() // Store UUIDs of favorite plants


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
    
    func fetchMostRecentDocumentForAllPlants() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        for plant in favoritePlants {
            print(plant.plant_name)
            await fetchMostRecentAverage(userId: uid, plantId: plant.id, periodicity: "daily", sensor: "heat")
        }
    }

//    func fetchMostRecentHeat(userId: String, plantId: UUID, periodicity: String, sensor: String){
//        var total = 0
//        var count = 0
//        
//        let db = Firestore.firestore()
//
//        let documentRef = db.collection("users")
//            .document(userId)
//            .collection("plants")
//            .document(plantId.uuidString)
//            .collection(periodicity)
//        
//        documentRef.getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let document = querySnapshot?.documents.first else {
//                return
//            }
//                        
//            let secondRef = db.collection("users")
//                .document(userId)
//                .collection("plants")
//                .document(plantId.uuidString)
//                .collection(periodicity)
//                .document(document.documentID)
//                .collection(sensor)
//            
//            secondRef.getDocuments { (secondSnapshot, error) in
//                for document in secondSnapshot!.documents {
//                    let value = document.data()[sensor] as? Int
//                    total += value ?? 0
//                    count += 1
//                }
//                print(total / count)
//            }
//        }
//    }
    
    
    func fetchMostRecentAverage(userId:String, plantId: UUID, periodicity: String, sensor: String) async{
        let db = Firestore.firestore()
        do {
            let documentRef = db.collection("users")
                .document(userId)
                .collection("plants")
                .document(plantId.uuidString)
                .collection(periodicity)
            
            let querySnapshot = try await documentRef.getDocuments().documents.first
            let secondRef = db.collection("users")
                .document(userId)
                .collection("plants")
                .document(plantId.uuidString)
                .collection(periodicity)
                .document(querySnapshot?.documentID ?? "Error")
                .collection(sensor)
            
            let secondSnapshot = try await secondRef.getDocuments()
            
            var total = 0
            var count = 0
            for document in secondSnapshot.documents {
                let value = document.data()[sensor] as? Int
                total += value ?? 0
                count += 1
            }
            if (count != 0){
                print(total/count)
            }

        } catch {
          print("Error getting documents: \(error)")
        }

    }

}

