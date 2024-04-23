import Firebase
import SwiftUI

class GraphDataViewmodel: ObservableObject {
    //var plot = GraphPlot()
    var sensorTypes:[String] = ["heat","humidity","moisture","temperature","timestamp"]
    var sunValues: [Double] = []
    var humidityValues: [Double] = []
    var temperatureValues: [Double] = []
    var moistureValues: [Double] = []
    var timestampValues:[Double] = []
    
    
    var fetchedData: [Double] = []
    //(timestamp, value)
    var sunGraphPoints: [(Double, Double)] = []
    var humidityGraphPoints: [(Double, Double)] = []
    var temperatureGraphPoints: [(Double, Double)] = []
    var moistureGraphPoints: [(Double, Double)] = []
    var timestampGraphPoints: [(Double, Double)] = []
    
    var avgMoisture: Double = 0.0
    var avgTemperature: Double = 0.0
    var avgHumidity: Double = 0.0
    var avgSun: Double = 0.0
    
    @Published var isDataFetched = false
    @Published var isCalculated = false
    
    func formatDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    func fetchSensorDataForPlant(plantId: String, collectionRef: String, documentId: String, sensorType: String, completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        let db = Firestore.firestore()

        if sensorType == "all" {
            var allValuesFetched = 0 // Counter to track if all values for all sensor types have been fetched
            for sensor in sensorTypes {
                let readingsRef = db.collection("users")
                    .document(userId)
                    .collection("plants")
                    .document(plantId)
                    .collection(collectionRef)
                    .document(documentId)
                    .collection(sensor)

                readingsRef.getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error fetching documents for sensor \(sensor): \(error)")
                        // Handle error if needed
                        return
                    }

                    guard let documents = snapshot?.documents, !documents.isEmpty else {
                        // No documents found for this sensor type
                        // Handle if needed
                        return
                    }
                    

                    // Extract field value from each document and save to the appropriate array
                    for document in documents {
                        let data = document.data()
                        if let value = data[sensor] as? Double {
                            switch sensor {
                            case "heat":
                                if let timestamp = data["timestamp"] as? Double{
                                    self.sunGraphPoints.append((timestamp, value))
                                }
                                self.sunValues.append(value)
                            case "humidity":
                                if let timestamp = data["timestamp"] as? Double{
                                    self.humidityGraphPoints.append((timestamp, value))
                                }
                                self.humidityValues.append(value)
                            case "temperature":
                                if let timestamp = data["timestamp"] as? Double{
                                    self.temperatureGraphPoints.append((timestamp, value))
                                }
                                self.temperatureValues.append(value)
                            case "moisture":
                                if let timestamp = data["timestamp"] as? Double{
                                    self.moistureGraphPoints.append((timestamp, value))
                                }
                                self.moistureValues.append(value)
                            case "timestamp":
                                
                                self.timestampValues.append(value)
                            default:
                                break
                            }
                        }
                    }
                    // Sort the data points based on timestamps
                    self.sunGraphPoints.sort { $0.0 < $1.0 }
                    self.humidityGraphPoints.sort { $0.0 < $1.0 }
                    self.temperatureGraphPoints.sort { $0.0 < $1.0 }
                    self.moistureGraphPoints.sort { $0.0 < $1.0 }
                    // Separate the sorted data points back into timestamp and value arrays
                    self.timestampValues.sort()
                    switch sensorType {
                    case "heat":
                        self.sunValues = self.sunGraphPoints.map { $0.1 }
                    case "humidity":
                        self.humidityValues = self.humidityGraphPoints.map { $0.1 }
                    case "temperature":
                        self.temperatureValues = self.temperatureGraphPoints.map { $0.1 }
                    case "moisture":
                        self.moistureValues = self.moistureGraphPoints.map { $0.1 }
                    default:
                        break
                    }

                    // Increment the counter
                    allValuesFetched += 1

                    // Check if all values for all sensor types have been fetched
                    if allValuesFetched == self.sensorTypes.count {
                        DispatchQueue.main.async {
                            self.isDataFetched = true
                            
                            print("All data fetched")
                            //print(self.sunValues)
                            /*
                            print("Sun Values: \(self.sunValues)")
                            print("Humidity Values: \(self.humidityValues)")
                            print("Temperature Values: \(self.temperatureValues)")
                            print("Moisture Values: \(self.moistureValues)")
                             */
                            completion()
                        }
                    }
                }
            }
        } else {
            let readingsRef = db.collection("users")
                .document(userId)
                .collection("plants")
                .document(plantId)
                .collection(collectionRef)
                .document(documentId)
                .collection(sensorType)

            readingsRef.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching documents for sensor \(sensorType): \(error)")
                    // Handle error if needed
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    // No documents found for this sensor type
                    // Handle if needed
                    return
                }
                
                // Extract field value from each document and save to the appropriate array
                for document in documents {
                    let data = document.data()
                    if let value = data[sensorType] as? Double {
                        switch sensorType {
                        case "heat":
                            self.sunValues.append(value)
                        case "humidity":
                            self.humidityValues.append(value)
                        case "temperature":
                            self.temperatureValues.append(value)
                        case "moisture":
                            self.moistureValues.append(value)
                        case "timestamp":
                            self.timestampValues.append(value)
                        default:
                            break
                        }
                    }
                }
                self.isDataFetched = true

                completion()
            }
        }
    }


    func calculate(values: [Double]) -> Double {
        guard !values.isEmpty else {
            return 0.0 // Return 0 if there are no values
        }
        let total = values.reduce(0, +)
        return total / Double(values.count)
    }
    func calculateAverage(plantId: String, collection: String, documentId: String, sensorType: String, completion: @escaping () -> Void) {
        if sensorType == "all" {
            fetchSensorDataForPlant(plantId: plantId, collectionRef: collection, documentId: documentId, sensorType: sensorType) {
                //DispatchQueue.main.asyncAfter(deadline: .now() + 0.35){
                // Once data is fetched, calculate averages for all sensor types
                self.avgSun = self.calculate(values: self.sunValues)
                self.avgHumidity = self.calculate(values: self.humidityValues)
                self.avgTemperature = self.calculate(values: self.temperatureValues)
                self.avgMoisture = self.calculate(values: self.moistureValues)
                self.isCalculated = true
                // Print averages
                /*
                 print("Average Sun: \(self.avgSun)")
                 print("Average Humidity: \(self.avgHumidity)")
                 print("Average Temperature: \(self.avgTemperature)")
                 print("Average Moisture: \(self.avgMoisture)")
                 */
            }
            //print
            completion()
            
            
        } else {
            fetchSensorDataForPlant(plantId: plantId, collectionRef: collection, documentId: documentId, sensorType: sensorType) {
                // Once data is fetched, calculate the average for the specific sensor type
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.35){
                switch sensorType {
                case "heat":
                    self.avgSun = self.calculate(values: self.sunValues)
                case "humidity":
                    self.avgHumidity = self.calculate(values: self.humidityValues)
                case "temperature":
                    self.avgTemperature = self.calculate(values: self.temperatureValues)
                case "moisture":
                    self.avgMoisture = self.calculate(values: self.moistureValues)
                default:
                    break
                    // Print average
                }
                //print("Average \(sensorType.capitalized): \(self.calculateAverage(values: self.sensorValues(for: sensorType)))")
                self.isCalculated=true
                
            }
            completion()
            
        }
    }
    func fetchSensorValues(plantId: String, collectionRef: String, documentId: String, sensorType: String) -> [Double] {
        
        fetchSensorDataForPlant(plantId: plantId, collectionRef: collectionRef, documentId: documentId, sensorType: sensorType) {
            
            switch sensorType {
            case "heat":
                self.fetchedData = self.sunValues
            case "humidity":
                self.fetchedData =  self.humidityValues
            case "temperature":
                self.fetchedData =  self.temperatureValues
            case "moisture":
                self.fetchedData =  self.moistureValues
            case "timestamp":
                self.fetchedData =  self.timestampValues
            default:
                break
            }
            print("maddddddddd\(self.fetchedData)")
            
            
        }
        //print("pleasssssss\(self.plot.datas)")
        return (fetchedData)
    }
    /*
    func updateAverageDisplay(plantId:String) {
            guard let userId = Auth.auth().currentUser?.uid else {
                print("User not logged in")
                return
            }
            
        fetchAndCalculateAverage(userId: userId, plantId: plantId, collection: "weekly", documentId: formatDate(Date(), format: "yyyy-'W'ww"), sensorType:sType ) { average, error in
                DispatchQueue.main.async {
                    if let average = average {
                        print("Average moisture: \(average)")
                        
                        // Update any relevant UI elements with this average
                    } else if let error = error {
                        print("Error calculating average: \(error)")
                        
                    }
                }
            }
        }
    */
    
    
}


