//
//  individual_plant_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI

struct IndividualPlantView: View {
    @StateObject var viewmodel = individualplant_viewmodel()
    @EnvironmentObject var bluetooth: bluetooth_viewmodel
    @State var selectedOption: String? = nil
    @State private var isActive = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @State private var showNavigationBar = true
    let my_plant: Plant

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
                    
                    Text("Moisture: \(viewmodel.moisture)")
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
                    
                    Text("Temperature: \(viewmodel.fahrenheit-7)")
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
                    
                    Text("Humidity: \(viewmodel.humidity)")
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
                        NavigationLink(destination: GraphWeek(my_plant: my_plant)) {
                            Text("More Info")
                                .foregroundColor(.black)
                                .bold()
                                .font(.system(size: 25))
                        }
                            .buttonStyle(PlainButtonStyle())
                    )
                    .padding(.top, 10)
                
                Button("Save Data"){
                    viewmodel.led = bluetooth.bluetoothModel.ledCharacteristicInt ?? 999
                    viewmodel.moisture = bluetooth.bluetoothModel.moistureCharacteristicInt ?? 999
                    viewmodel.humidity = bluetooth.bluetoothModel.humidityCharacteristicInt ?? 999
                    viewmodel.fahrenheit = bluetooth.bluetoothModel.fahrenheitCharacteristicInt ?? 999
                    viewmodel.heatIndex = bluetooth.bluetoothModel.heatIndexCharacteristicInt ?? 999
                }
            }
            .onAppear(){
                viewmodel.plant_id = my_plant.id.uuidString
                let my_peripheral = bluetooth.bluetoothModel.connectedPeripheral
                if (my_peripheral != nil) {
                    bluetooth.readLEDCharacteristic()
                    bluetooth.readMoistureCharacteristic()
                    bluetooth.readHumidityCharacteristic()
                    bluetooth.readFahrenheitCharacteristic()
                    bluetooth.readHeatIndexCharacteristic()
                    
                    viewmodel.led = bluetooth.bluetoothModel.ledCharacteristicInt ?? 999
                    viewmodel.moisture = bluetooth.bluetoothModel.moistureCharacteristicInt ?? 999
                    viewmodel.humidity = bluetooth.bluetoothModel.humidityCharacteristicInt ?? 999
                    viewmodel.fahrenheit = bluetooth.bluetoothModel.fahrenheitCharacteristicInt ?? 999
                    viewmodel.heatIndex = bluetooth.bluetoothModel.heatIndexCharacteristicInt ?? 999
                }
            }
            .toolbar {
                ToolbarItemGroup() {
                    Button(action: {
                        print("About tapped!")
                    }) {
                        Label("About", systemImage: "square.and.pencil")
                    }
                }
            }
            
            //Back button to plant page
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button (action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 30)) // Adjust the size as needed
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    })
                    .onTapGesture {
                        withAnimation {
                            showNavigationBar.toggle()
                        }
                    }
                }
            }
        }
    }
}
    


// Noah worked on this. I found a solution in stack overflow to preview with passing arguments. I'm not sure if its a bug but we have to return the preview. Otherwise we can use environment variables.
// https://stackoverflow.com/questions/76468134/how-to-create-a-swiftui-preview-in-xcode-15-for-a-view-with-a-binding
#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            let testPlant = Plant(plant_name: "Cactus", plant_type: "Pincushion", plant_description: "My indoor prickly cactus", plant_image: "Flower")
            IndividualPlantView(my_plant: testPlant).environmentObject(bluetooth_viewmodel())
        }
    }
    return PreviewWrapper()
}


