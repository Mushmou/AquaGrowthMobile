import SwiftUI

struct GraphWeek: View {
    
    @ObservedObject var viewModel = GraphWeekViewmodel()
    @ObservedObject var data = GraphDataViewmodel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedItem: String = "moisture"
    @State private var isExpanded = false
    let options = ["moisture", "temperature", "humidity", "sun"]
    
    let my_plant: Plant
    
    init(my_plant: Plant) {
        self.my_plant = my_plant
        viewModel.calculateAllAverages(plantId: my_plant.id.uuidString, weekId: data.currentWeekId)
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
                    
                    switch selectedItem{
                    case "moisture":
                        GraphPlotView(plantId: my_plant.id.uuidString, sensorType: "moisture", dayweekmonthId: "week", date: data.currentWeekId)
                            .frame(height: 310)
                    case "temperature":
                        GraphPlotView(plantId: my_plant.id.uuidString, sensorType: "temperature", dayweekmonthId: "week", date: data.currentWeekId)
                            .frame(height: 310)
                    case "humidity":
                        GraphPlotView(plantId: my_plant.id.uuidString, sensorType: "humidity", dayweekmonthId: "week", date: data.currentWeekId)
                            .frame(height: 310)
                    case "sun":
                        GraphPlotView(plantId: my_plant.id.uuidString, sensorType: "light", dayweekmonthId: "week", date: data.currentWeekId)
                            .frame(height: 310)
                    default:
                        GraphPlotView(plantId: my_plant.id.uuidString, sensorType: "moisture", dayweekmonthId: "week", date: data.currentWeekId)
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
        .frame(maxWidth: .infinity) // This ensures the green background takes the full width
        .background(Color(red: 0.28, green: 0.59, blue: 0.17))
        .cornerRadius(12)
    }
    
    private var dateRangeView: some View {
            Text("Week of \(viewModel.weekDateRange)")
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
        .padding(.top, 10)
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
        HStack {
            ForEach(["Day", "Week", "Month"], id: \.self) { period in
                Button(action: {
                    switch period {
                    case "Day":
                        selectedItem = "Day"
                    case "Week":
                        selectedItem = "Week"
                    case "Month":
                        selectedItem = "Month"
                    default:
                        break
                    }
                }) {
                    Text(period)
                        .bold()
                        .foregroundColor(selectedItem == period ? .white : .black)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(selectedItem == period ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
        }
        .padding(.horizontal)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

}

struct DataView: View {
    let title: String
    let value: String
    let imageName: String
    
    var body: some View {
        VStack {
            Text(title)
            Text(value)
            Image(imageName)
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
}
