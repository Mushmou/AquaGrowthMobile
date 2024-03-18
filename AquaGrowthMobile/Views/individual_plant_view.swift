//
//  individual_plant_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI

struct IndividualPlantView: View {
    
    let my_plant: Plant
    
    init(my_plant: Plant) {
        self.my_plant = my_plant
    }
    @State var selectedOption: String? = nil

    var body: some View {
        NavigationStack{
            VStack() {
                
                VStack{
                    HStack{
                        Spacer()
                        Text(my_plant.plant_name)
                            .font(.system(size: 32))
                            .bold()
                        Spacer()
                    }
                    Text(my_plant.plant_type)
                        .font(.system(size: 12))
                }
                
                Spacer()
                
                Image(my_plant.plant_image)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 5)
                    )
                
                Text(my_plant.plant_description)
                    .font(.system(size: 24))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                HStack{
                    Image("Water")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text("Moisture")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                    .padding(.bottom, 30)
                
                
                HStack{
                    Image("Temperature")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text("Temperature")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                    .padding(.bottom, 30)

                
                HStack{
                    Image("Humidity")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text("Humidity")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                    .padding(.bottom, 30)

                Spacer()
                
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: 200, height: 40)
                    .foregroundColor(.gray)
                    .overlay(
                        NavigationLink(destination: GraphWeek()) {
                            Text("More Info")
                                .foregroundColor(.black)
                                .bold()
                                .font(.system(size: 25))
                        }
                        .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove the default button style
                    )
                    .padding(.top, 10)
            }
//            .navigationTitle(my_plant.plant_name)
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(
//                leading:
//                    HStack{
//                        Spacer()
//                        Text(my_plant.plant_name)
//                            .font(.system(size: 32))
//                            .bold()
//                        Spacer()
//                        
//                        Button(action: {
//                            // Action for adding a new plant
//                            print("Add Plant Clicked")
//                            
//                        }) {
//                            Image(systemName: "plus")
//                        }
//                    }.border(.red)
//            )
            
            .toolbar {
                ToolbarItemGroup() {
                    Button(action: {
                        print("About tapped!")
                    }) {
                        Label("About", systemImage: "square.and.pencil")
                    }
                }
            }
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarTitle(Text("Dashboard").font(.subheadline), displayMode: .large)
        }
    }
}


// Noah worked on this. I found a solution in stack overflow to preview with passing arguments. I'm not sure if its a bug but we have to return the preview. Otherwise we can use environment variables.
// https://stackoverflow.com/questions/76468134/how-to-create-a-swiftui-preview-in-xcode-15-for-a-view-with-a-binding
#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            let testPlant = Plant(plant_name: "Cactus", plant_type: "Pincushion", plant_description: "My indoor prickly cactus", plant_image: "Flower")
            IndividualPlantView(my_plant: testPlant)
        }
    }
    return PreviewWrapper()
}


