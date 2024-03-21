//
//  graph_da_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
// Edited by Jaxon 3/13/24 | 3/20

import Foundation
import SwiftUI

struct GraphDay: View {
    @StateObject var viewModel = GraphDayViewmodel()
    @State private var showNavigationBar = true
    @State private var selectedOption: String? = nil
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    let my_plant: Plant
    
    init(my_plant: Plant) {
        self.my_plant = my_plant
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                ZStack{
                    Rectangle()
                        .fill(Color(red: 0.28, green: 0.59, blue: 0.17))
                        .frame(width: UIScreen.main.bounds.width, height: 250)
                        .position(x: UIScreen.main.bounds.width / 2, y: 30)
                    
                    Rectangle()
                        .fill(.white)
                        .frame(width: UIScreen.main.bounds.width, height: 640)
                        .position(x: UIScreen.main.bounds.width / 2, y: 550)
                    
                    Text(my_plant.plant_name)
                        .font(.system(size: 50))
                        .bold()
                        .position(x: UIScreen.main.bounds.width / 2, y: 50)
                        .foregroundColor(.white)
                    
                    Text(my_plant.plant_type)
                        .font(.system(size: 20))
                        .position(x: UIScreen.main.bounds.width / 2, y: 90)
                        .foregroundColor(.white)
                    
                    Rectangle() //Graph Box
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 325)
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.72)
                        
                    Rectangle() //Date Box
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: UIScreen.main.bounds.width - 100, height: 40)
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4.5)
                    
                    //Gray box on day
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray)
                        .frame(width: UIScreen.main.bounds.width / 6.5, height: 35)
                        .position(x: UIScreen.main.bounds.width / 4.8, y: 189)
                }
                
            //Day Week Month
                ZStack{
                    VStack{
                        HStack (spacing: 40){
                            NavigationLink(
                                destination: GraphDay(my_plant: my_plant),
                                tag: "Day",
                                selection: $selectedOption
                            ) {
                                Text("Day")
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: selectedOption == "Day" ? 2 : 0))
                            }
                            .isDetailLink(false)
                            
                            NavigationLink(destination: GraphWeek(my_plant:my_plant),
                                           tag: "Week", selection: $selectedOption) {
                                Text("Week")
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: selectedOption == "Week" ? 2 : 0))
                            }.isDetailLink(false)
                            
                            NavigationLink(destination: GraphMonth(my_plant:my_plant),
                                           tag: "Month", selection: $selectedOption) {
                                Text("Month")
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: selectedOption == "Month" ? 2 : 0))
                            }.isDetailLink(false)
                        }
                        .font(.system(size: 23))
                        .padding(.top,167)
                        
                    }
                }
            }
            ZStack{
                VStack(spacing:148){
                //Date range at the top
                    Text(viewModel.dayDateRange)
                        .padding(.bottom,220)
                        .foregroundColor(.black)
                        .font(.system(size: 27))
                        .bold()
                    
                //Date calendar list in the graph
                    HStack(spacing:-26){
                        // Display the week's dates
                        ForEach(viewModel.dayDateList, id:\.self) { date in
                            Text(date)
                                .padding()
                        }
                    }
                    .font(.system(size: 14))
                }
                .padding(.bottom,125)
            }
        }
        
        //Back button to plant page
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    selectedOption = "Back"
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 30))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
        }
        .background(
            NavigationLink(
                destination: IndividualPlantView(my_plant: my_plant), // Change this to your desired destination
                tag: "Back",
                selection: $selectedOption,
                label: { EmptyView() }
            )
        )

    }
}

#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            let testPlant = Plant(plant_name: "Cactus", plant_type: "Pincushion", plant_description: "My indoor prickly cactus", plant_image: "Flower")
            GraphDay(my_plant: testPlant)
        }
    }
    return PreviewWrapper()
}

                


