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
        var currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        var dates: [String] = []
        
        // Loop to get dates for the previous 7 days
        for _ in 0..<7 {
            dates.append(dateFormatter.string(from: currentDate))
            if let nextDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) {
                currentDate = nextDate
            }
        }
        self.weekDateList = dates.reversed()
        if let firstDate = weekDateList.first, let lastDate = weekDateList.last {
            self.weekDateRange = "\(firstDate) - \(lastDate)"
        }
    }
    
    

}
