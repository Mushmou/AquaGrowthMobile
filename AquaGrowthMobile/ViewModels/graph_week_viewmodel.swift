import Foundation

class GraphWeekViewmodel: ObservableObject {
    @Published var data: GraphDataViewmodel
    
    @Published var weekDateList: [String] = []
    @Published var weekDateRange: String = ""
    //@Published var plantId: String=""
    
    
    
    init() {
        self.data = GraphDataViewmodel()
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


    
    

}
