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
    func generateMonthDateList() {
        var currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        var dates: [String] = []
        
        // Loop to get dates for the previous 30 days
        for _ in 0..<7 {
            dates.append(dateFormatter.string(from: currentDate))
            if let nextDate = Calendar.current.date(byAdding: .day, value: -5, to: currentDate) {
                currentDate = nextDate
            }
        }
        self.monthDateList = dates.reversed()
        if let firstDate = monthDateList.first, let lastDate = monthDateList.last {
            self.monthDateRange = "\(firstDate) - \(lastDate)"
        }
    }
    
}

