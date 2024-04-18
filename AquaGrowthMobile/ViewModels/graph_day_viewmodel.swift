//
//  graph_day_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
// Edited by Jaxon on 3/13/24

import Foundation

class GraphDayViewmodel: ObservableObject{
    @Published var dayDateList: [String] = []
    @Published var dayDateRange: String = ""
    
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
        
}
