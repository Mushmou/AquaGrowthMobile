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
        var dayWeekId = ""
        for week in allWeeksInMonth{
            getDaysInWeek(weekId: week)
            for day in allDaysInWeek{
                if dayId == day{
                    dayWeekId = week
                }
            }
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
            .collection(dayWeekId)
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
        getDaysInWeek(weekId: weekId)
        
        let db = Firestore.firestore()
        
        // Dispatch group to wait for all queries to finish
        let dispatchGroup = DispatchGroup()
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
    
    func calculate(values: [Double]) -> Double {
        self.isCalculated = false
        guard !values.isEmpty else {
            return 0.0 // Return 0 if there are no values
        }
        var total = 0.0
        for val in values{
            total += val
        }
        //let total = values.reduce(0, +)
        self.isCalculated = true
        return total / Double(values.count)
    }
    
    func fetchGraphPoints(plantId:String, sensorType:String, dayweekmonth:String, date:String, completion: @escaping () -> Void){
        
        switch dayweekmonth {
        case "day":
            switch sensorType{
            case "heat":
                fetchDaySensorData(plantId: plantId, sensor: sensorType, dayId: date){
                    self.fetchDaySensorData(plantId: plantId, sensor: "timestamp", dayId: date){
                        // Check if there are any timestamp values
                        guard !self.timestampValues.isEmpty else {
                            completion()
                            return
                        }
                        //self.sunGraphPoints.removeAll()
                        
                        var hourlySunValues = [Int: [Double]]()
                        for (timestamp, sun) in zip(self.timestampValues, self.sunValues) {
                            let date = Date(timeIntervalSince1970: timestamp)
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: date)
                            if hourlySunValues[hour] == nil {
                                hourlySunValues[hour] = [sun]
                            } else {
                                hourlySunValues[hour]?.append(sun)
                            }
                        }
                        
                        for hour in hourlySunValues.keys.sorted() {
                            if let sunValues = hourlySunValues[hour] {
                                let avgSun = self.calculate(values: sunValues)
                                let timestamp = Double(hour)
                                self.sunGraphPoints.append((timestamp, avgSun))
                            }
                        }
                        self.sunGraphPoints.sort { $0.0 > $1.0 }
                        print(self.sunGraphPoints)
                        completion()
                    }
                }
            case "humidity":
                fetchDaySensorData(plantId: plantId, sensor: sensorType, dayId: date){
                    self.fetchDaySensorData(plantId: plantId, sensor: "timestamp", dayId: date){
                        // Check if there are any timestamp values
                        guard !self.timestampValues.isEmpty else {
                            completion()
                            return
                        }
                        //self.humidityGraphPoints.removeAll()
                        
                        var hourlyHumidityValues = [Int: [Double]]()
                        for (timestamp, humidity) in zip(self.timestampValues, self.humidityValues) {
                            let date = Date(timeIntervalSince1970: timestamp)
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: date)
                            if hourlyHumidityValues[hour] == nil {
                                hourlyHumidityValues[hour] = [humidity]
                            } else {
                                hourlyHumidityValues[hour]?.append(humidity)
                            }
                        }
                        
                        for hour in hourlyHumidityValues.keys.sorted() {
                            if let humidityValues = hourlyHumidityValues[hour] {
                                let avgHum = self.calculate(values: humidityValues)
                                let timestamp = Double(hour)
                                self.humidityGraphPoints.append((timestamp, avgHum))
                            }
                        }
                        self.humidityGraphPoints.sort { $0.0 > $1.0 }
                        print(self.humidityGraphPoints)
                        completion()
                    }
                }
            case "temperature":
                fetchDaySensorData(plantId: plantId, sensor: sensorType, dayId: date){
                    self.fetchDaySensorData(plantId: plantId, sensor: "timestamp", dayId: date){
                        // Check if there are any timestamp values
                        guard !self.timestampValues.isEmpty else {
                            completion()
                            return
                        }
                        //self.temperatureGraphPoints.removeAll()
                        
                        var hourlyTempValues = [Int: [Double]]()
                        for (timestamp, temp) in zip(self.timestampValues, self.temperatureValues) {
                            let date = Date(timeIntervalSince1970: timestamp)
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: date)
                            if hourlyTempValues[hour] == nil {
                                hourlyTempValues[hour] = [temp]
                            } else {
                                hourlyTempValues[hour]?.append(temp)
                            }
                        }
                        
                        for hour in hourlyTempValues.keys.sorted() {
                            if let tempValues = hourlyTempValues[hour] {
                                let avgTemp = self.calculate(values: tempValues)
                                let timestamp = Double(hour)
                                self.temperatureGraphPoints.append((timestamp, avgTemp))
                            }
                        }
                        self.temperatureGraphPoints.sort { $0.0 > $1.0 }
                        print(self.temperatureGraphPoints)
                        completion()
                    }
                }
            case "moisture":
                fetchDaySensorData(plantId: plantId, sensor: sensorType, dayId: date){
                    self.fetchDaySensorData(plantId: plantId, sensor: "timestamp", dayId: date){
                        // Check if there are any timestamp values
                        guard !self.timestampValues.isEmpty else {
                            completion()
                            return
                        }
                        //self.moistureGraphPoints.removeAll()
                        
                        var hourlyMoistureValues = [Int: [Double]]()
                        for (timestamp, moi) in zip(self.timestampValues, self.moistureValues) {
                            let date = Date(timeIntervalSince1970: timestamp)
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: date)
                            if hourlyMoistureValues[hour] == nil {
                                hourlyMoistureValues[hour] = [moi]
                            } else {
                                hourlyMoistureValues[hour]?.append(moi)
                            }
                        }
                        
                        for hour in hourlyMoistureValues.keys.sorted() {
                            if let moiValues = hourlyMoistureValues[hour] {
                                let avgMoi = self.calculate(values: moiValues)
                                let timestamp = Double(hour)
                                self.moistureGraphPoints.append((timestamp, avgMoi))
                            }
                        }
                        self.moistureGraphPoints.sort { $0.0 > $1.0 }
                        print(self.moistureGraphPoints)
                        completion()
                    }
                }
            default:
                break
            }
            

            
        case "week":
            switch sensorType {
            case "heat":
                var previousSunAvg: Double? = nil
                var daysProcessed = 0
                
                for (index, day) in self.allDaysInWeek.enumerated() {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                        self.sunValues = []
                        self.fetchDaySensorData(plantId: plantId, sensor: sensorType, dayId: day) {
                            // Calculate average humidity value for the day
                            var avgSun: Double = 0.0
                            if !self.sunValues.isEmpty {
                                avgSun = self.calculate(values: self.sunValues)
                                previousSunAvg = avgSun
                            } else if let prevAvg = previousSunAvg {
                                avgSun = prevAvg
                            } else {
                                avgSun = 00.0 // Default value
                            }
                            
                            //self.humidityGraphPoints.append((timestamp, avgHumidity))
                            self.sunGraphPoints.append((Double(daysProcessed), avgSun))
                            
                            // Check if all days have been processed
                            daysProcessed += 1
                            if daysProcessed == self.allDaysInWeek.count {
                                self.sunGraphPoints.sort { $0.0 > $1.0 }
                                print (self.sunGraphPoints)
                                completion() // Call completion after all days are processed
                            }
                        }
                    }
                    
                }
            case "humidity":
                var previousHumAvg: Double? = nil
                var daysProcessed = 0
                
                for (index, day) in self.allDaysInWeek.enumerated() {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                        self.humidityValues = []
                        self.fetchDaySensorData(plantId: plantId, sensor: sensorType, dayId: day) {
                            // Calculate average humidity value for the day
                            var avgHumidity: Double = 0.0
                            if !self.humidityValues.isEmpty {
                                avgHumidity = self.calculate(values: self.humidityValues)
                                previousHumAvg = avgHumidity
                            } else if let prevAvg = previousHumAvg {
                                avgHumidity = prevAvg
                            } else {
                                avgHumidity = 00.0 // Default value
                            }
                            
                            //self.humidityGraphPoints.append((timestamp, avgHumidity))
                            self.humidityGraphPoints.append((Double(daysProcessed), avgHumidity))
                            
                            // Check if all days have been processed
                            daysProcessed += 1
                            if daysProcessed == self.allDaysInWeek.count {
                                self.humidityGraphPoints.sort { $0.0 > $1.0 }
                                print (self.humidityGraphPoints)
                                completion() // Call completion after all days are processed
                            }
                        }
                    }
                }
                
            case "temperature":
                var previousTempAvg: Double? = nil
                var daysProcessed = 0
                
                for (index, day) in self.allDaysInWeek.enumerated() {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                        self.temperatureValues = []
                        self.fetchDaySensorData(plantId: plantId, sensor: sensorType, dayId: day) {
                            // Calculate average humidity value for the day
                            var avgTemp: Double = 0.0
                            if !self.temperatureValues.isEmpty {
                                avgTemp = self.calculate(values: self.temperatureValues)
                                previousTempAvg = avgTemp
                            } else if let prevAvg = previousTempAvg {
                                avgTemp = prevAvg
                            } else {
                                avgTemp = 00.0 // Default value
                            }
                            
                            //self.humidityGraphPoints.append((timestamp, avgHumidity))
                            self.temperatureGraphPoints.append((Double(daysProcessed), avgTemp))
                            
                            // Check if all days have been processed
                            daysProcessed += 1
                            if daysProcessed == self.allDaysInWeek.count {
                                self.temperatureGraphPoints.sort { $0.0 > $1.0 }
                                print (self.temperatureGraphPoints)
                                completion() // Call completion after all days are processed
                            }
                        }
                    }
                    
                }
            case "moisture":
                var previousMoiAvg: Double? = nil
                var daysProcessed = 0
                for (index, day) in self.allDaysInWeek.enumerated() {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.25) {
                        self.moistureValues = []
                        self.fetchDaySensorData(plantId: plantId, sensor: sensorType, dayId: day) {
                            //print(day, self.moistureValues)
                            // Calculate average humidity value for the day
                            var avgMoisture: Double = 0.0
                            if !self.moistureValues.isEmpty {
                                avgMoisture = self.calculate(values: self.moistureValues)
                                previousMoiAvg = avgMoisture
                            } else if let prevAvg = previousMoiAvg {
                                avgMoisture = prevAvg
                            } else {
                                avgMoisture = 0.0 // Default value
                            }
                            
                            //self.humidityGraphPoints.append((timestamp, avgHumidity))
                            self.moistureGraphPoints.append((Double(daysProcessed), avgMoisture))
                            
                            // Check if all days have been processed
                            daysProcessed += 1
                            if daysProcessed == self.allDaysInWeek.count {
                                self.moistureGraphPoints.sort { $0.0 > $1.0 }
                                print (self.moistureGraphPoints)
                                completion() // Call completion after all days are processed
                            }
                        }
                    }
                }
            default:
                break
            }
            
        case "month":
            switch sensorType {
            case "heat":
                var previousSunAvg: Double? = nil
                var daysProcessed = 0
                var totalDays:[String] = []
                
                for week in allWeeksInMonth {
                    self.getDaysInWeek(weekId: week)
                    for day in allDaysInWeek{
                        if self.compareMonths(day: day, month: self.currentMonthId){
                            totalDays.append(day)
                            
                        }
                    }
                }
                //print (totalDays.count)
                for (index, day) in totalDays.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                        
                        //print(day)
                        self.sunValues = []
                        self.fetchDaySensorData(plantId: plantId, sensor: sensorType, dayId: day) {
                            //print(dayId)
                            // Calculate average heat value for the day
                            var avgSun: Double = 0.0
                            if !self.sunValues.isEmpty {
                                avgSun = self.calculate(values: self.sunValues)
                                //print("l", self.sunValues)
                                previousSunAvg = avgSun
                            } else if let prevAvg = previousSunAvg {
                                avgSun = prevAvg
                            } else {
                                avgSun = 00.0 // Default value
                            }
                            
                            self.sunGraphPoints.append((Double(daysProcessed), avgSun))
                            
                            // Check if all days have been processed
                            daysProcessed += 1
                            //print("dayprocess", daysProcessed)
                            if daysProcessed == totalDays.count {
                                self.sunGraphPoints.sort { $0.0 > $1.0 }
                                print(self.sunGraphPoints)
                                print("Loaded")
                                completion()
                            }
                        }
                        
                    }
                }
                
            case "humidity":
                var previousHumAvg: Double? = nil
                var daysProcessed = 0
                var totalDays:[String] = []
                
                for week in allWeeksInMonth {
                    self.getDaysInWeek(weekId: week)
                    for day in allDaysInWeek{
                        if self.compareMonths(day: day, month: self.currentMonthId){
                            totalDays.append(day)
                            
                        }
                    }
                }
                
                for (index, day) in totalDays.enumerated() {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                        self.humidityValues = []
                        self.fetchDaySensorData(plantId: plantId, sensor: sensorType, dayId: day) {
                            // Calculate average humidity value for the day
                            var avgHumidity: Double = 0.0
                            if !self.humidityValues.isEmpty {
                                avgHumidity = self.calculate(values: self.humidityValues)
                                previousHumAvg = avgHumidity
                            } else if let prevAvg = previousHumAvg {
                                avgHumidity = prevAvg
                            } else {
                                avgHumidity = 00.0 // Default value
                            }
                            
                            //self.humidityGraphPoints.append((timestamp, avgHumidity))
                            self.humidityGraphPoints.append((Double(daysProcessed), avgHumidity))
                            
                            // Check if all days have been processed
                            daysProcessed += 1
                            if daysProcessed == totalDays.count {
                                
                                self.humidityGraphPoints.sort { $0.0 > $1.0 }
                                print (self.humidityGraphPoints)
                                print("Loaded")
                                completion()                            }
                        }
                    }
                }
                
            case "temperature":
                var previousTempAvg: Double? = nil
                var daysProcessed = 0
                var totalDays:[String] = []
                
                for week in allWeeksInMonth {
                    self.getDaysInWeek(weekId: week)
                    for day in allDaysInWeek{
                        if self.compareMonths(day: day, month: self.currentMonthId){
                            totalDays.append(day)
                            
                        }
                    }
                }
                
                for (index, day) in totalDays.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                        self.temperatureValues = []
                        self.fetchDaySensorData(plantId: plantId, sensor: sensorType, dayId: day) {
                            // Calculate average humidity value for the day
                            var avgTemp: Double = 0.0
                            if !self.temperatureValues.isEmpty {
                                avgTemp = self.calculate(values: self.temperatureValues)
                                previousTempAvg = avgTemp
                            } else if let prevAvg = previousTempAvg {
                                avgTemp = prevAvg
                            } else {
                                avgTemp = 00.0 // Default value
                            }
                            
                            //self.humidityGraphPoints.append((timestamp, avgHumidity))
                            self.temperatureGraphPoints.append((Double(daysProcessed), avgTemp))
                            
                            // Check if all days have been processed
                            daysProcessed += 1
                            if daysProcessed == totalDays.count {
                                self.temperatureGraphPoints.sort { $0.0 > $1.0 }
                                print (self.temperatureGraphPoints)
                                print("Loaded")
                                completion()
                            }
                        }
                    }
                    
                }
            case "moisture":
                var previousMoiAvg: Double? = nil
                var daysProcessed = 0
                var totalDays:[String] = []
                
                for week in allWeeksInMonth {
                    self.getDaysInWeek(weekId: week)
                    for day in allDaysInWeek{
                        if self.compareMonths(day: day, month: self.currentMonthId){
                            totalDays.append(day)
                            
                        }
                    }
                }
                
                for (index, day) in totalDays.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                        self.moistureValues = []
                        self.fetchDaySensorData(plantId: plantId, sensor: sensorType, dayId: day) {
                            // Calculate average humidity value for the day
                            var avgMoisture: Double = 0.0
                            if !self.moistureValues.isEmpty {
                                avgMoisture = self.calculate(values: self.moistureValues)
                                previousMoiAvg = avgMoisture
                            } else if let prevAvg = previousMoiAvg {
                                avgMoisture = prevAvg
                            } else {
                                avgMoisture = 0.0 // Default value
                            }
                            
                            //self.humidityGraphPoints.append((timestamp, avgHumidity))
                            self.moistureGraphPoints.append((Double(daysProcessed), avgMoisture))
                            
                            // Check if all days have been processed
                            daysProcessed += 1
                            if daysProcessed == totalDays.count {
                                self.moistureGraphPoints.sort { $0.0 > $1.0 }
                                print (self.moistureGraphPoints)
                                print("Loaded")
                                completion()
                            }
                        }
                    }
                }
            default:
                break
            }
        default:
            break
        }
    
    }
    func hourComponent(from timestamp: TimeInterval) -> Int {
        let date = Date(timeIntervalSince1970: timestamp)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        return hour
    }
    
    func compareMonths(day:String, month:String) ->Bool{
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        guard let ddate = dayFormatter.date(from: day) else {
            print("Failed to parse the date string.")
            return false
        }
        let mmDateFormatter = DateFormatter()
        mmDateFormatter.dateFormat = "MM"
        let dayMonthString = mmDateFormatter.string(from: ddate)
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "yyyy-MM"
        guard let mdate = monthFormatter.date(from: month) else{
            print("Fail")
            return false
        }
        
        let monthMonthString = mmDateFormatter.string(from: mdate)
        
        if dayMonthString == monthMonthString{
            return true
        }
        return false
    }

}


