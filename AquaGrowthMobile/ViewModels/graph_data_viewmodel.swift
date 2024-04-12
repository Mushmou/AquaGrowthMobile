import Firebase

class GraphDataViewmodel: ObservableObject {
    var sunValues: [Double] = []
    var humidityValues: [Double] = []
    var temperatureValues: [Double] = []
    var moistureValues: [Double] = []
    
    var avgMoisture: Double = 0.0
    var avgTemperature: Double = 0.0
    var avgHumidity: Double = 0.0
    var avgSun: Double = 0.0
    
    //@Published var isActive = false
    
    func getAvg(datatype: String)->Double{
        if datatype == "moisture"{
            return avgMoisture
        }
        return avgMoisture
    }
    
    func fetchSensorDataForPlant(plantId: String, collectionRef: String, completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
                
        let db = Firestore.firestore()
        
        // Assuming Firebase structure as described
       // let collectionRefs = ["daily", "weekly", "monthly"]
        
        db.collection("users").document(userId)
            .collection("plants").document(plantId)
            .collection(collectionRef)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let readingsArray = data["readings"] as? [[String: Any]] {
                        for reading in readingsArray {
                            if let heat = reading["heat"] as? Double,
                               let humidity = reading["humidity"] as? Double,
                               let temperature = reading["temperature"] as? Double,
                               let moisture = reading["moisture"] as? Double,
                               let timestamp = reading["timestamp"] as? Double {
                                DispatchQueue.main.async {
                                    self.sunValues.append(heat)
                                    self.humidityValues.append(humidity)
                                    self.temperatureValues.append(temperature)
                                    self.moistureValues.append(moisture)
                                    //self.timestampValues.append(Date(timeIntervalSince1970: timestamp))
                                }
                            }
                        }
                    }
                }
        }
        /*
        DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
            print("sun \(self.sunValues)")
            print("hum \(self.humidityValues)")
            print("temp \(self.temperatureValues)")
            print("moi \(self.moistureValues)")            
        }
         */
        
    }
    
    func calculateAverages(plantId: String, collection: String, completion: @escaping () -> Void){
        var count = 0.0
        fetchSensorDataForPlant(plantId: plantId, collectionRef:collection){}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            //guard !data.weeklyData.isEmpty else { return }
            print ("calculated")
            var totalMoisture = 0.0
            print(self.moistureValues)
            for val in self.moistureValues{
                count += 1
                totalMoisture = totalMoisture + val
            }
            self.avgMoisture = totalMoisture / count
            
            count = 0.0
            var totalTemperature = 0.0
            for val in self.temperatureValues{
                count += 1
                totalTemperature = totalTemperature + val
            }
            self.avgTemperature = totalTemperature / count
            
            var totalHumidity = 0.0
            count = 0.0
            for val in self.humidityValues{
                count += 1
                totalHumidity = totalHumidity + val
            }
            self.avgHumidity = totalHumidity / count
            
            var totalHeat = 0.0
            count = 0.0
            for val in self.sunValues{
                count += 1
                totalHeat = totalHeat + val
            }
            self.avgSun = totalHeat / count

            print("total \(totalMoisture)")
            print("avg \(self.avgMoisture)")
            completion()
        }
    }
    
}
