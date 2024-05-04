import Foundation

class GraphWeekViewmodel: ObservableObject {
    var data = GraphDataViewmodel()
    
    @Published var weekDateList: [String] = []
    @Published var weekDateRange: String = ""
    
    
    @Published var isCalculated = false
    var avgMoisture: Double = 0.0
    var avgTemperature: Double = 0.0
    var avgHumidity: Double = 0.0
    var avgSun: Double = 0.0
    
    
    
    init() {
        //self.data = GraphDataViewmodel()
        generateWeekDateList()
    }
    func generateWeekDateList() {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Set Monday as the first day of the week

        // Get the current date
        let currentDate = Date()

        // Get the start date of the current week
        guard let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) else {
            print("Error: Failed to calculate the start date of the week")
            return
        }

        var currentDateForIteration = startDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        var dates: [String] = []

        // Loop to get dates for the current week starting from the calculated start date
        for _ in 0..<7 {
            dates.append(dateFormatter.string(from: currentDateForIteration))
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDateForIteration) {
                currentDateForIteration = nextDate
            }
        }

        self.weekDateList = dates
        if let firstDate = weekDateList.first, let lastDate = weekDateList.last {
            self.weekDateRange = "\(firstDate) - \(lastDate)"
        }
    }
    
    func calculate(values: [Double]) -> Double {
        self.isCalculated = false
        guard !values.isEmpty else {
            return 0.0 // Return 0 if there are no values
        }
        let total = values.reduce(0, +)
        self.isCalculated = true
        return total / Double(values.count)
    }
    
    func calculateAllAverages(plantId: String, weekId:String) {
        data.fetchWeekSensorData(plantId: plantId, sensor: "humidity", weekId: weekId){
            self.avgHumidity = self.calculate(values: self.data.humidityValues)
        }
        data.fetchWeekSensorData(plantId: plantId, sensor: "heat", weekId: weekId){
            self.avgSun = self.calculate(values: self.data.sunValues)
        }
        data.fetchWeekSensorData(plantId: plantId, sensor: "temperature", weekId: weekId){
            self.avgTemperature = self.calculate(values: self.data.temperatureValues)
        }
        data.fetchWeekSensorData(plantId: plantId, sensor: "moisture", weekId: weekId){
            self.avgMoisture = self.calculate(values: self.data.moistureValues)
        }
    }

    
    

}
