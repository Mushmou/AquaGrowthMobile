//
//  graph_week_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//  Edited by Jaxon on 3/13/24

import Foundation

class GraphWeekViewModel: ObservableObject {
    @Published var weekDateList: [String] = []
    @Published var weekDateRange: String = ""
    @Published var temperatureData: [Double] = [22, 24, 21, 23, 25, 27, 26] // Example temperature data
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    init() {
        generateWeekDates()
    }
    
    private func generateWeekDates() {
        let calendar = Calendar.current
        let today = Date()
        var dateList: [String] = []
        
        for dayOffset in (0..<7).reversed() {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                dateList.append(dateFormatter.string(from: date))
            }
        }
        
        DispatchQueue.main.async {
            self.weekDateList = dateList
            self.updateWeekDateRange()
        }
    }
    
    private func updateWeekDateRange() {
        if let firstDate = weekDateList.first, let lastDate = weekDateList.last {
            weekDateRange = "\(firstDate) - \(lastDate)"
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
