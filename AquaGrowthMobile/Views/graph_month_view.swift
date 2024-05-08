import SwiftUI

struct GraphMonth: View {
    
    @ObservedObject var viewModel = GraphMonthViewmodel()
    @ObservedObject var data = GraphDataViewmodel()
    
    @State private var selectedItem: String = "moisture"
    let options = ["moisture", "temperature", "humidity", "sun"]
    
    let my_plant: Plant
    
    init(my_plant: Plant) {
        self.my_plant = my_plant
        viewModel.calculateAllAverages(plantId: my_plant.id.uuidString)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    topInfoView
                    
                    dateRangeView
                    
                    if viewModel.isCalculated {
                        dataAveragesView
                    } else {
                        ProgressView("Fetching data...")
                    }
                    
                    sensorPicker
                    
                    navigationLinks
                    
                    if selectedItem == "sun"{
                        GraphPlotView(plantId: my_plant.id.uuidString, sensorType: "light", dayweekmonthId: "month", date: data.currentMonthId)
                        .frame(height: 310)
                    }
                    else{
                        GraphPlotView(plantId: my_plant.id.uuidString, sensorType: selectedItem, dayweekmonthId: "month", date: data.currentMonthId)
                            .frame(height: 310)
                    }
                                    
                }
                .padding(.horizontal)
            }
            .navigationBarHidden(true)
        }
    }
    
    private var topInfoView: some View {
        VStack {
            Text(my_plant.plant_name)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            Text(my_plant.plant_type)
                .font(.title3)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.28, green: 0.59, blue: 0.17))
        .cornerRadius(12)
    }
    
    private var dateRangeView: some View {
        Text("Month of \(viewModel.monthDateRange)")
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
    }
    
    private var dataAveragesView: some View {
        HStack(spacing: 15) {
            DataView(title: "Avg. Moi.", value: "\(String(format: "%.1f", viewModel.avgMoisture))%", imageName: "Water")
            DataView(title: "Avg. Temp.", value: "\(String(format: "%.1f", viewModel.avgTemperature))°F", imageName: "temperature_original")
            DataView(title: "Avg. Hum.", value: "\(String(format: "%.1f", viewModel.avgHumidity))%", imageName: "humidity_original")
            DataView(title: "Avg. Sun", value: "\(String(format: "%.1f", viewModel.avgSun))%", imageName: "sun_original")
        }
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var sensorPicker: some View {
        Picker("Select Sensor", selection: $selectedItem) {
            ForEach(options, id: \.self) { option in
                Text(option.capitalized)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
    
    
    private var navigationLinks: some View {
        HStack(spacing: 40) {
            NavigationLink("Day", destination: GraphDay(my_plant: my_plant))
            NavigationLink("Week", destination: GraphWeek(my_plant: my_plant))
            NavigationLink("Month", destination: GraphMonth(my_plant: my_plant))
        }
        .padding(.top, 10)
    }
}

