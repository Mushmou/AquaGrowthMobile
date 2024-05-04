

import Foundation
import SwiftUI

struct IndividualPlantView: View {
    @StateObject var viewmodel = individualplant_viewmodel()
    @EnvironmentObject var bluetooth: bluetooth_viewmodel
    @State var selectedOption: String? = nil
    @State private var isActive = false

    @State private var isEditingPlant = false
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingGraphPage = false

    @State private var moisture: Int = 0// State to hold the moisture value
    @State private var temperature: Int = 0 // State to hold the moisture value
    @State private var humidity: Int = 0 // State to hold the moisture value

    @State private var isFavorite: Bool = false // State to hold the favorite status

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
                    Spacer()
                    Image("Water")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text("Moisture: \(moisture) %")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding(.bottom, 30)
                
                
                HStack{
                    Spacer()
                    Image("temperature_original")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text("Temperature: \(temperature) °F")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 30)
                
                
                HStack{
                    Spacer()
                    Image("humidity_original")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text("Humidity: \(humidity) %")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 30)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: 200, height: 40)
                    .foregroundColor(.green)
                    .overlay(
                        Button(action: {
                        // Show Graph view when "More Info" button is clicked
                            isShowingGraphPage = true
                        }) {
                            Text("More Info")
                                .foregroundColor(.white)
                                .bold()
                                .font(.system(size: 25))
                            }
                            .buttonStyle(PlainButtonStyle())
                    )
                    .padding(.top, 10)
                    // Present GraphWeek as a  sheet
                    .sheet(isPresented: $isShowingGraphPage) {
                        GraphWeek(my_plant: my_plant)
                    }

                
                Button("Save Data"){
                    viewmodel.SavedSensorInformation()
                }
            }
            .onAppear(){
                bluetooth.readLEDCharacteristic()
                bluetooth.readLightCharacteristic()
                bluetooth.readHumidityCharacteristic()
                bluetooth.readMoistureCharacteristic()
                bluetooth.readFahrenheitCharacteristic()
                bluetooth.readHeatIndexCharacteristic()
                
                viewmodel.led = bluetooth.bluetoothModel.ledCharacteristicInt ?? 0
                viewmodel.moisture = bluetooth.bluetoothModel.moistureCharacteristicInt ?? 0
                viewmodel.humidity = bluetooth.bluetoothModel.humidityCharacteristicInt ?? 0
                viewmodel.fahrenheit = bluetooth.bluetoothModel.fahrenheitCharacteristicInt ?? 0
                viewmodel.heatIndex = bluetooth.bluetoothModel.heatIndexCharacteristicInt ?? 0
                viewmodel.lightIndex = bluetooth.bluetoothModel.lightCharacteristicInt ?? 0
                
                viewmodel.plant_id = my_plant.id.uuidString
                viewmodel.fetchLatestDailyMoisture { fetchedMoisture in
                    // Update the moisture state with the fetched value
                    self.moisture = fetchedMoisture ?? 0
                }
                viewmodel.fetchLatestDailyTemperature { fetchedTemperature in
                    // Update the moisture state with the fetched value
                    self.temperature = fetchedTemperature ?? 0
                }
                viewmodel.fetchLatestDailyHumidity{ fetchedHumidity in
                    // Update the moisture state with the fetched value
                    self.humidity = fetchedHumidity ?? 0
                }
                // Fetch favorite status and update the button
                viewmodel.fetchFavoriteStatus { isFavorite in
                    self.isFavorite = isFavorite
                }
            }
            // Link to Edit Plant View
            .toolbar {
                            // Add favorite button --> Added by Danny 04/17
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    viewmodel.setFavorite()
                                    isFavorite.toggle()
                                    print("Clicked favorite")
                                }) {
                                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                                        .foregroundColor(isFavorite ? .red : .black) // Change color based on favorite status
                                }
                            }
                            
                            // Edit button
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    isEditingPlant = true
                                }) {
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 20))
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                }
                            }
                        }
            .navigationDestination(isPresented: $isEditingPlant){
                EditPlantView(plant: my_plant)
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
