//
//  graph_month_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
// Edited by Jaxon on 3/13/24

import Foundation

class GraphMonthViewmodel: ObservableObject{
    @Published var monthDateList: [String] = []
    @Published var monthDateRange: String = ""
    
    init(){
        generateMonthDateList()
    }
    func formatDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    func generateMonthDateList() {
        let calendar = Calendar.current

        // Get the current date
        let currentDate = Date()

        // Get the start date of the current month
        guard let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else {
            print("Error: Failed to calculate the start date of the month")
            return
        }

        // Get the end date of the current month
        guard let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) else {
            print("Error: Failed to calculate the end date of the month")
            return
        }

        var currentDateForIteration = startDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        var dates: [String] = []

        // Calculate the number of days to skip between each date
        let daysToSkip = max(1, (calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 0) / 6)

        // Loop to get dates for the current month starting from the calculated start date
        while currentDateForIteration <= endDate {
            dates.append(dateFormatter.string(from: currentDateForIteration))
            if dates.count >= 7 {
                break
            }
            if let nextDate = calendar.date(byAdding: .day, value: daysToSkip, to: currentDateForIteration) {
                currentDateForIteration = nextDate
            }
        }

        self.monthDateList = dates
        self.monthDateRange = "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }



    
}

