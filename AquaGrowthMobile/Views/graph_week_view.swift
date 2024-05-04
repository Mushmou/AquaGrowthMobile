
import Foundation
import SwiftUI

struct GraphWeek: View {
    
    @ObservedObject var viewModel = GraphWeekViewmodel()
    @ObservedObject var data = GraphDataViewmodel()
    
    @State private var showNavigationBar = true
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedOption: String? = nil
    @State private var isDataFetched = false
    //vars for drop down
    @State private var isExpanded = false
    @State private var selectedItem: String = "moisture"
    let options = ["moisture", "temperature", "humidity", "sun"]

    
    let my_plant: Plant
    
    init(my_plant: Plant) {
        self.my_plant = my_plant
        viewModel.calculateAllAverages(plantId: my_plant.id.uuidString, weekId: data.currentWeekId)
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
                    
                    //bar to indicate you can swipe page down
                    RoundedRectangle(cornerRadius: 40)
                        .frame(width: 200, height: 5)
                        .foregroundColor(.gray)
                        .position(x: UIScreen.main.bounds.width / 2, y: 40)
                    
                    //plant name
                    Text(my_plant.plant_name)
                        .font(.system(size: 50))
                        .bold()
                        .position(x: UIScreen.main.bounds.width / 2, y: 70)
                        .foregroundColor(.white)
                    
                    //plant type
                    Text(my_plant.plant_type)
                        .font(.system(size: 20))
                        .position(x: UIScreen.main.bounds.width / 2, y: 105)
                        .foregroundColor(.white)
                    
                    ZStack {
                        Rectangle() // Graph Box
                            .stroke(Color.black, lineWidth: 2)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 335)
                            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.70)
                        
                        //to check when the sensor type is changed from the drop down
                        if isExpanded {
                            ProgressView("Fetching Data...")
                                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.67)
                            
                        }
                        else {
                            if selectedItem == "sun"{
                                GraphPlotView(plantId: my_plant.id.uuidString,sensorType: "heat", dayweekmonthId: "week", date: data.currentWeekId)
                                    .frame(width: UIScreen.main.bounds.width - 25, height: 310)
                                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.67)
                            }
                            else{
                                GraphPlotView(plantId: my_plant.id.uuidString,sensorType: selectedItem, dayweekmonthId: "week", date: data.currentWeekId)
                                    .frame(width: UIScreen.main.bounds.width - 25, height: 310)
                                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.67)
                            }
                        }
                    }
                    Rectangle() //Date Box
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: UIScreen.main.bounds.width - 100, height: 40)
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4.5)
                    
                    //Gray box on week
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.gray)
                        .frame(width: UIScreen.main.bounds.width / 4.45, height: 35)
                        .position(x: UIScreen.main.bounds.width / 2.15, y: 189)
                }
                
                //Data Averages
                ZStack{
                    if viewModel.isCalculated{
                        HStack(spacing: 15){
                            VStack(spacing:5){
                                Text("Avg. Moi.")
                                Text("\(String(format: "%.1f", viewModel.avgMoisture))%")
                                Image("Water")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            VStack(spacing:5){
                                Text("Avg. Temp.")
                                Text("\(String(format: "%.1f", viewModel.avgTemperature))°F")
                                Image("Temperature")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            VStack(spacing:5){
                                Text("Avg. Hum.")
                                Text("\(String(format: "%.1f", viewModel.avgHumidity))%")
                                Image("Humidity")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            VStack(spacing:5){
                                Text("Avg. Sun")
                                Text("\(String(format: "%.1f", viewModel.avgSun))%")
                                Image("Sun")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .position(x: UIScreen.main.bounds.width / 2, y: 290)
                        
                    } else {
                        ProgressView("Fetching data...")
                            .padding(.top,50)
                            
                      }  
                }
                
                //drop down box
                ZStack{
                    VStack{
                        RoundedRectangle(cornerRadius: 40)
                            .frame(width: 200, height: 35)
                            .foregroundColor(.gray)
                            .overlay(
                                VStack{
                                    if selectedItem == selectedItem {
                                        Text(selectedItem)
                                            .bold()
                                            .font(.system(size: 23))
                                            .padding(.vertical, 5)
                                    }
                                }
                            )
                            .onTapGesture {
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            }
                            .position(x: UIScreen.main.bounds.width / 2, y: 360)

                        if isExpanded {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 200, height: CGFloat((options.count) * 40))
                                .foregroundColor(.gray)
                                //current option
                                .overlay(
                                    VStack{
                                        if selectedItem == selectedItem {
                                            Text(selectedItem)
                                                .bold()
                                                .font(.system(size: 23))
                                                .padding(.bottom, 126)
                                        }
                                    }
                                )
                                //list options
                                .overlay(
                                    VStack(spacing:10){
                                        ForEach(options.filter { $0 != selectedItem }, id: \.self) { option in
                                            Button(action: {
                                                selectedItem = option
                                                isExpanded.toggle()
                                            }) {
                                                Text(option)
                                            }
                                            .foregroundColor(.black)
                                            .bold()
                                            .font(.system(size: 23))
                                        }
                                    }
                                        .padding(.top, 18)
                                )
                                .position(x: UIScreen.main.bounds.width / 2, y: 313)
                        }
                    }
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
                        .padding(.top,168)
                    }
                }
            }
            ZStack{
                VStack(spacing:148){
                //Date range at the top
                    Text(viewModel.weekDateRange)
                        .padding(.bottom,220)
                        .foregroundColor(.black)
                        .font(.system(size: 27))
                        .bold()
                    
                //Date calendar list in the graph
                    
                    HStack(spacing:-26){
                        // Display the week's dates
                        ForEach(viewModel.weekDateList, id:\.self) { date in
                            Text("")
                                .padding()
                        }
                    }
                    .font(.system(size: 14))
                     
                }
                .padding(.bottom,125)
                
            }
            
            
        }
        .navigationBarHidden(true)
    }
    
}




#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            let testPlant = Plant(plant_name: "Cactus", plant_type: "Pincushion", plant_description: "My indoor prickly cactus", plant_image: "Flower")
            GraphWeek(my_plant: testPlant)
            //GraphPlotView()
        }
    }
    return PreviewWrapper()
}
