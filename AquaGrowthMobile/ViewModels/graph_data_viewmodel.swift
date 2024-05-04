import Firebase
import SwiftUI

class GraphDataViewmodel: ObservableObject {
    var currentMonthId:String = ""
    var currentWeekId:String = ""
    var currentDayId:String = ""
    
    var allWeeksInMonth:[String] = []
    var allDaysInWeek:[String] = []
    
    
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
    
    init(){
        setDates()
        
    }
    
    func formatDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    func setDates(){
        
        currentMonthId = self.formatDate(Date(), format: "yyyy-MM")
        currentWeekId = self.formatDate(Date(), format: "yyyy-'W'ww")
        currentDayId = self.formatDate(Date(), format: "yyyy-MM-dd")
        getWeeksInMonth()
        getDaysInWeek(weekId:currentWeekId)
        //(weekId: "2024-W18")
        
    }
    
//Get all weeks in the month
    func getWeeksInMonth(){
        let calendar = Calendar.current
        
        // Get the current month and year
        let currentDate = Date()
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        // Get the first day of the month
        var startDateOfMonthComponents = DateComponents()
        startDateOfMonthComponents.year = currentYear
        startDateOfMonthComponents.month = currentMonth
        startDateOfMonthComponents.day = 1
        // Clear the array before appending new weeks
        allWeeksInMonth.removeAll()
        // Get the first day of the current month
        let firstDayOfMonth = calendar.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1))!
        // Get the number of weeks in the month
        let weekRange = calendar.range(of: .weekOfMonth, in: .month, for: firstDayOfMonth)!
        // Iterate through each week of the month
        for week in 1...weekRange.count {
            // Calculate the start date of the week
            if let startDateOfWeek = calendar.date(byAdding: .weekOfYear, value: week - 1, to: firstDayOfMonth) {
                allWeeksInMonth.append(self.formatDate(startDateOfWeek, format:"yyyy-'W'ww"))
            }
        }
        //print(allWeeksInMonth)
    }

//Get all days in the week
    func getDaysInWeek(weekId:String){
        let calendar = Calendar.current
        
        // Clear the array before appending new days
        allDaysInWeek.removeAll()
        
        // Extract year and week number from the provided weekId
        let components = weekId.components(separatedBy: "-W")
        guard components.count == 2, let year = Int(components[0]), let weekNumber = Int(components[1]) else {
            print("Invalid weekId format")
            return
        }
        //print (components)
        // Get the date of the first day of the week
        guard let firstDayOfWeek = calendar.date(from: DateComponents(weekOfYear: weekNumber, yearForWeekOfYear: year)) else {
            print("Failed to get the first day of the week")
            return
        }
        //("First Day of Week: \(self.formatDate(firstDayOfWeek, format: "yyyy-MM-dd"))")
        
        // Iterate through each day of the week
        for day in 0..<7 {
            // Calculate the date for each day of the week
            if let dateOfDay = calendar.date(byAdding: .day, value: day, to: firstDayOfWeek) {
                allDaysInWeek.append(self.formatDate(dateOfDay, format: "yyyy-MM-dd"))
            }
        }
        
        //print(allDaysInWeek)
    }
        
    func fetchDaySensorData(plantId:String, sensor:String, dayId:String, completion:@escaping () -> Void){
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        
        let db = Firestore.firestore()
        
        // Dispatch group to wait for all queries to finish
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter() // Enter dispatch group
        
        let monthRef = db.collection("users")
            .document(userId)
            .collection("plants")
            .document(plantId)
            .collection("monthly")
            .document(currentMonthId)
            .collection(currentWeekId)
            .document(dayId)
            .collection(sensor)
        
        monthRef.getDocuments { (snapshot, error) in
            defer {
                dispatchGroup.leave() // Leave dispatch group even if an error occurs
            }
            if let error = error {
                print("Error fetching documents for sensor \(sensor): \(error)")
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                // No documents found for this sensor type
                return
            }
            
            // get value from each document and save to the appropriate array
            for document in documents {
                let data = document.data()
                if let value = data[sensor] as? Double {
                    //print("VALUE", value)
                    switch sensor {
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
        }

        dispatchGroup.notify(queue: .main) {
                // All queries have finished
                self.isDataFetched = true
                completion()
        }
        
    }
    func fetchWeekSensorData(plantId:String, sensor:String, weekId:String, completion:@escaping () -> Void){
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        
        let db = Firestore.firestore()
        
        // Dispatch group to wait for all queries to finish
        let dispatchGroup = DispatchGroup()
        self.getDaysInWeek(weekId: weekId)
        for day in allDaysInWeek {
            dispatchGroup.enter() // Enter dispatch group
            
            let monthRef = db.collection("users")
                .document(userId)
                .collection("plants")
                .document(plantId)
                .collection("monthly")
                .document(currentMonthId)
                .collection(weekId)
                .document(day)
                .collection(sensor)
            
            monthRef.getDocuments { (snapshot, error) in
                defer {
                    dispatchGroup.leave() // Leave dispatch group even if an error occurs
                }
                if let error = error {
                    print("Error fetching documents for sensor \(sensor): \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    // No documents found for this sensor type
                    return
                }
                
                // get value from each document and save to the appropriate array
                for document in documents {
                    let data = document.data()
                    if let value = data[sensor] as? Double {
                        //print("VALUE", value)
                        switch sensor {
                        case "heat":
                            self.sunValues.append(value)
                        case "humidity":
                            self.humidityValues.append(value)
                            //print(self.humidityValues)
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
            }
        }

        dispatchGroup.notify(queue: .main) {
                // All queries have finished
                self.isDataFetched = true
                completion()
        }
        
    }
    
    func fetchMonthSensorData(plantId: String, sensor: String, completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        let db = Firestore.firestore()
        
        // Dispatch group to wait for all queries to finish
        let dispatchGroup = DispatchGroup()
        
        for week in allWeeksInMonth {
            self.getDaysInWeek(weekId: week)
            
            for day in allDaysInWeek {
                dispatchGroup.enter() // Enter dispatch group
                
                let monthRef = db.collection("users")
                    .document(userId)
                    .collection("plants")
                    .document(plantId)
                    .collection("monthly")
                    .document(currentMonthId)
                    .collection(week)
                    .document(day)
                    .collection(sensor)
                
                monthRef.getDocuments { (snapshot, error) in
                    defer {
                        dispatchGroup.leave() // Leave dispatch group even if an error occurs
                    }
                    
                    if let error = error {
                        print("Error fetching documents for sensor \(sensor): \(error)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents, !documents.isEmpty else {
                        // No documents found for this sensor type
                        return
                    }
                    
                    // get value from each document and save to the appropriate array
                    for document in documents {
                        let data = document.data()
                        if let value = data[sensor] as? Double {
                            //print("VALUE", value)
                            switch sensor {
                            case "heat":
                                self.sunValues.append(value)
                            case "humidity":
                                self.humidityValues.append(value)
                                //print(self.humidityValues)
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
                }
            }
            
        }

        dispatchGroup.notify(queue: .main) {
                // All queries have finished
                self.isDataFetched = true
                completion()
        }
    }
    
    func fetchGraphPoints(plantId:String, sensorType:String, dayweekmonth:String, date:String, completion: @escaping () -> Void){
        switch dayweekmonth{
        case "day":
            fetchDaySensorData(plantId: plantId, sensor: sensorType, dayId: date){
                self.fetchDaySensorData(plantId: plantId, sensor: "timestamp", dayId: date){
                    // Check if there are any timestamp values
                    guard !self.timestampValues.isEmpty else {
                        completion()
                        return
                    }
                    for i in 0...(self.timestampValues.count-1){
                        switch sensorType {
                        case "heat":
                            self.sunGraphPoints.append((self.timestampValues[i], self.sunValues[i]))
                            // Sort the data points based on timestamps
                            self.sunGraphPoints.sort { $0.0 < $1.0 }
                            completion()
                        case "humidity":
                            self.humidityGraphPoints.append((self.timestampValues[i], self.humidityValues[i]))
                            self.humidityGraphPoints.sort { $0.0 < $1.0 }
                            completion()
                        case "temperature":
                            self.temperatureGraphPoints.append((self.timestampValues[i], self.temperatureValues[i]))
                            self.temperatureGraphPoints.sort { $0.0 < $1.0 }
                            completion()
                        case "moisture":
                            self.moistureGraphPoints.append((self.timestampValues[i], self.moistureValues[i]))
                            self.moistureGraphPoints.sort { $0.0 < $1.0 }
                            completion()
                        default:
                            break
                        }
                    }
                }
            }
            
        case "week":
            fetchWeekSensorData(plantId: plantId, sensor: sensorType, weekId: date){
                self.fetchWeekSensorData(plantId: plantId, sensor: "timestamp", weekId: date){
                    // Check if there are any timestamp values
                    guard !self.timestampValues.isEmpty else {
                        completion()
                        return
                    }
                    for i in 0...(self.timestampValues.count-1){
                        switch sensorType {
                        case "heat":
                            self.sunGraphPoints.append((self.timestampValues[i], self.sunValues[i]))
                            // Sort the data points based on timestamps
                            self.sunGraphPoints.sort { $0.0 < $1.0 }
                            completion()
                        case "humidity":
                            self.humidityGraphPoints.append((self.timestampValues[i], self.humidityValues[i]))
                            self.humidityGraphPoints.sort { $0.0 < $1.0 }
                            completion()
                        case "temperature":
                            self.temperatureGraphPoints.append((self.timestampValues[i], self.temperatureValues[i]))
                            self.temperatureGraphPoints.sort { $0.0 < $1.0 }
                            completion()
                        case "moisture":
                            self.moistureGraphPoints.append((self.timestampValues[i], self.moistureValues[i]))
                            self.moistureGraphPoints.sort { $0.0 < $1.0 }
                            completion()
                        default:
                            break
                        }
                    }
                    
                }
            }
            
        case "month":
            fetchMonthSensorData(plantId: plantId, sensor: sensorType){
                self.fetchMonthSensorData(plantId: plantId, sensor: "timestamp"){
                    // Check if there are any timestamp values
                    guard !self.timestampValues.isEmpty else {
                        completion()
                        return
                    }
                    for i in 0...(self.timestampValues.count-1){
                        switch sensorType {
                        case "heat":
                            self.sunGraphPoints.append((self.timestampValues[i], self.sunValues[i]))
                            // Sort the data points based on timestamps
                            self.sunGraphPoints.sort { $0.0 < $1.0 }
                            completion()
                        case "humidity":
                            self.humidityGraphPoints.append((self.timestampValues[i], self.humidityValues[i]))
                            self.humidityGraphPoints.sort { $0.0 < $1.0 }
                            completion()
                        case "temperature":
                            self.temperatureGraphPoints.append((self.timestampValues[i], self.temperatureValues[i]))
                            self.temperatureGraphPoints.sort { $0.0 < $1.0 }
                            completion()
                        case "moisture":
                            self.moistureGraphPoints.append((self.timestampValues[i], self.moistureValues[i]))
                            self.moistureGraphPoints.sort { $0.0 < $1.0 }
                            completion()
                        default:
                            break
                        }
                    }
                }
            }
        default:
            break
        }
    }

}


