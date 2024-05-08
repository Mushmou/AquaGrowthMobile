import Foundation

class GraphDayViewmodel: ObservableObject{
    var data = GraphDataViewmodel()
    
    @Published var dayDateList: [String] = []
    @Published var dayDateRange: String = ""
    
    @Published var isCalculated = false
    var avgMoisture: Double = 0.0
    var avgTemperature: Double = 0.0
    var avgHumidity: Double = 0.0
    var avgSun: Double = 0.0
    
    init(){
        generateDayDateList()
    }
    func formatDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    func generateDayDateList() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        var dates: [String] = []
        
        dates.append(dateFormatter.string(from: currentDate))
        self.dayDateList = dates
        
        if let firstDate = dayDateList.first{
            self.dayDateRange = "\(firstDate)"
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
    
    func calculateAllAverages(plantId: String, dayId:String) {
        data.fetchDaySensorData(plantId: plantId, sensor: "humidity", dayId: dayId){
            self.avgHumidity = self.calculate(values: self.data.humidityValues)
        }
        data.fetchDaySensorData(plantId: plantId, sensor: "light", dayId: dayId){
            self.avgSun = self.calculate(values: self.data.sunValues)
        }
        data.fetchDaySensorData(plantId: plantId, sensor: "temperature", dayId: dayId){
            self.avgTemperature = self.calculate(values: self.data.temperatureValues)
        }
        data.fetchDaySensorData(plantId: plantId, sensor: "moisture", dayId: dayId){
            self.avgMoisture = self.calculate(values: self.data.moistureValues)
        }
    }
        
}
