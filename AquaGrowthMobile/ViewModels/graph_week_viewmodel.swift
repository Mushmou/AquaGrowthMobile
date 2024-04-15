//
//  graph_week_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//  Edited by Jaxon on 3/13/24

import Foundation

class GraphWeekViewmodel: ObservableObject{
    @Published var weekDateList: [String] = []
    @Published var weekDateRange: String = ""
    
    init(){
        generateWeekDateList()
        //generateWeekDateRange()
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
    /*
    func generateWeekDateRange() {
        var currentDate = Date()
        // Find the last day of the week (today)
        let endOfWeek = currentDate
        
        // Find the first day of the week (7 days ago)
        if let startOfWeek = Calendar.current.date(byAdding: .day, value: -6, to: endOfWeek) {
            // Format the dates
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d" // Format to display month and day
            
            // Create the range string
            let startDateString = dateFormatter.string(from: startOfWeek)
            let endDateString = dateFormatter.string(from: endOfWeek)
            
            self.weekDateRange = "\(startDateString) - \(endDateString)"
        }
    }
     */
}
