import SwiftUI
import DGCharts

struct GraphChart: UIViewRepresentable {
    var dataType: String
    var data: GraphDataViewmodel
    
    func makeUIView(context: Context) -> LineChartView {
        let chartView = LineChartView()
        chartView.data = generateLineChartData()
        return chartView
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        uiView.data = generateLineChartData()
    }
    
    private func generateLineChartData() -> LineChartData {
        let entries = dataEntriesForType()
        let dataSet = LineChartDataSet(entries: entries, label: dataType)
        dataSet.colors = [.blue]
        dataSet.circleColors = [.blue]
        dataSet.circleRadius = 4.0
        dataSet.mode = .cubicBezier
        dataSet.drawValuesEnabled = false
        let data = LineChartData(dataSet: dataSet)
        return data
    }
    
    private func dataEntriesForType() -> [ChartDataEntry] {
        switch dataType {
        case "Moisture":
            return data.moistureValues.enumerated().map { index, value in
                ChartDataEntry(x: Double(index), y: value)
            }
        case "Temperature":
            return data.temperatureValues.enumerated().map { index, value in
                ChartDataEntry(x: Double(index), y: value)
            }
        case "Humidity":
            return data.humidityValues.enumerated().map { index, value in
                ChartDataEntry(x: Double(index), y: value)
            }
        case "Sun":
            return data.sunValues.enumerated().map { index, value in
                ChartDataEntry(x: Double(index), y: value)
            }
        default:
            return []
        }
    }
}
