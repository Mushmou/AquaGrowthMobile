//
//  graph_month_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI

struct GraphMonth: View {
    //@StateObject var viewModel = graph_week_viewmodel()
    @State private var showNavigationBar = true
    @State private var selectedOption: String? = nil
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
            VStack{
                ZStack{
                    Rectangle()
                        .fill(Color(red: 0.28, green: 0.59, blue: 0.17))
                        .frame(width: UIScreen.main.bounds.width, height: 250) // Change the size of the VStack
                        .position(x: UIScreen.main.bounds.width / 2, y: 30)
                    
                    Rectangle()
                        .fill(.white)
                        .frame(width: UIScreen.main.bounds.width, height: 640) // Change the size of the VStack
                        .position(x: UIScreen.main.bounds.width / 2, y: 550)
                    
                    Text("Plant Name")
                        .font(.system(size: 50))
                        .bold()
                        .position(x: UIScreen.main.bounds.width / 2, y: 50)
                        .foregroundColor(.white)
                    Text("Plant Type")
                        .font(.system(size: 20))
                        .position(x: UIScreen.main.bounds.width / 2, y: 90)
                        .foregroundColor(.white)
                    
                    Rectangle() //Graph Box
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 325)
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.85)
                    
                    Rectangle() //Date Box
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: UIScreen.main.bounds.width - 100, height: 40)
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4.5)
                    //Day Week Month
                    HStack (spacing: 40){
                        NavigationLink(destination: GraphDay(),
                                       tag: "Day", selection: $selectedOption) {
                            Text("Day")
                                .bold()
                                .foregroundColor(.black)
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: selectedOption == "Day" ? 2 : 0))
                        }.isDetailLink(false)
                        
                        NavigationLink(destination: GraphWeek(),
                                       tag: "Week", selection: $selectedOption) {
                            Text("Week")
                                .bold()
                                .foregroundColor(.black)
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: selectedOption == "Week" ? 2 : 0))
                        }.isDetailLink(false)
                        
                        NavigationLink(destination: GraphMonth(),
                                       tag: "Month", selection: $selectedOption) {
                            Text("Month")
                                .bold()
                                .foregroundColor(.black)
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: selectedOption == "Month" ? 2 : 0))
                        }.isDetailLink(false)
                    }
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4.5)
                    .font(.system(size: 20))
                }
                // Back Button
                NavigationLink(destination: PlantView(),
                               tag: "Back", selection: $selectedOption) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 30)) // Adjust the size as needed
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }.isDetailLink(false)
                    .position(x: UIScreen.main.bounds.width / 9, y: UIScreen.main.bounds.height / -2.2)
            }
            
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    GraphMonth()
}

                
