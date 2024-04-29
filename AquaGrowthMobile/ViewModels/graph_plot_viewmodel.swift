import Foundation
import UIKit
import TinyConstraints
import DGCharts
import SwiftUI

class GraphPlot : UIViewController, ChartViewDelegate {
    @ObservedObject var data = GraphDataViewmodel()
    var sensorType: String
    var plantId: String
    var collection: String
    var documentId: String
    
    @Published var selectedYValue = 0.0
    var fetchedData: [Double] = []
    var timestamps: [Double] = []
    
    init(plantId: String, collection: String, documentId: String, sensorType: String) {
        self.sensorType = sensorType
        self.plantId = plantId
        self.collection = collection
        self.documentId = documentId
        
        //self.datas = datas
        //self.timestamps = timestamps
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.pinchZoomEnabled = true
        chartView.doubleTapToZoomEnabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .white
        let xAxis = chartView.xAxis
        xAxis.enabled = false
        //chartView.animate(xAxisDuration: 2.0)
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.delegate = self
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.height(to: view)
        setData()
        //fetchData{
        //    print("WORKKKK\(self.fetchedData)")
        //}
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard chartView == lineChartView else {
            return
        }
        selectedYValue = entry.y
        //print("Y-Value: \(entry.y)")
    }
    
    func setData() {
        data.fetchSensorDataForPlant(plantId: plantId, collectionRef: collection, documentId: documentId, sensorType: "all"){
            
            switch self.sensorType {
            case "heat":
                self.fetchedData = self.data.sunValues
            case "humidity":
                self.fetchedData =  self.data.humidityValues
            case "temperature":
                self.fetchedData =  self.data.temperatureValues
            case "moisture":
                self.fetchedData =  self.data.moistureValues
            default:
                break
            }
            self.timestamps = self.data.timestampValues
            guard let firstTimestamp = self.timestamps.first else {
                   return // Handle case where timestamps array is empty
               }
            //print(self.fetchedData)
            //print(self.timestamps)
            
            var chartDataEntries: [ChartDataEntry] = []
            for i in 0..<min(self.fetchedData.count, self.timestamps.count) {
                let time = self.timestampToNumericValue(timestamp:self.timestamps[i])
                print (self.fetchedData[i], time)
                let dataEntry = ChartDataEntry(x: time, y: self.fetchedData[i])
                chartDataEntries.append(dataEntry)
            }
            
            let dataSet = LineChartDataSet(entries: chartDataEntries, label: "Test")
            dataSet.mode = .horizontalBezier
            dataSet.lineWidth = 2
            dataSet.setColor(.black)
            dataSet.drawCirclesEnabled = false
            dataSet.highlightColor = .systemRed
            
            let data = LineChartData(dataSet: dataSet)
            data.setDrawValues(false)
            
            self.lineChartView.data = data
        }
        
    }
    let values: [ChartDataEntry] = [
            ChartDataEntry(x:0, y: 1),
            ChartDataEntry(x: 0.1, y: 15),
            ChartDataEntry(x:0.2, y: 10),
            ChartDataEntry(x: 0.3, y: 15),
            ChartDataEntry(x:0.4, y: 10),
            ChartDataEntry(x: 0.5, y: 15),
            ChartDataEntry(x:0.6, y: 10),
            ChartDataEntry(x: 0.7, y: 15),
            ChartDataEntry(x: 0.8, y: 15),
            ChartDataEntry(x:0.9, y: 10),
            ChartDataEntry(x: 1.0, y: 15),
            ChartDataEntry(x:1.2, y: 50),
        ]
    func timestampToNumericValue(timestamp: TimeInterval) -> Double {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddHHmmssSSS" // Month, Day, Hour, Minute, Second, Millisecond
        let dateString = dateFormatter.string(from: date)
        return Double(dateString) ?? 0.0 // Convert the string to a numerical value
    }
    func fetchData(completion: @escaping () -> Void){
        data.fetchSensorDataForPlant(plantId: plantId, collectionRef: collection, documentId: documentId, sensorType: "all"){
            
            switch self.sensorType {
            case "heat":
                self.fetchedData = self.data.sunValues
            case "humidity":
                self.fetchedData =  self.data.humidityValues
            case "temperature":
                self.fetchedData =  self.data.temperatureValues
            case "moisture":
                self.fetchedData =  self.data.moistureValues
            default:
                break
            }
            self.timestamps = self.data.timestampValues
            //print(self.fetchedData)
            //print(self.timestamps)
        }
        completion()
    }
}


struct GraphPlotView: UIViewControllerRepresentable {
    var fetchedData: [Double] = []
    var timestamps: [Double] = []
    var sensorType: String
    var plantId: String
    var collection: String
    var documentId: String
    @ObservedObject var data = GraphDataViewmodel()

    init(plantId: String, collection: String, documentId: String, sensorType: String) {
        self.sensorType = sensorType
        self.plantId = plantId
        self.collection = collection
        self.documentId = documentId
        //let data = GraphDataViewmodel()
        //data.fetchSensorDataForPlant(plantId: plantId, collectionRef: collection, documentId: documentId, sensorType: sensorType) {}
            
        //fetchedData = data.fetchSensorValues(plantId: plantId, collectionRef: collection, documentId: documentId, sensorType: sensorType)
        //timestamps = data.fetchSensorValues(plantId: plantId, collectionRef: collection, documentId: documentId, sensorType: "timestamp")
           // print("HELLLOOOO\(datas)")
        
        
        
    }
    /*
    mutating func fetchData(){
        data.fetchSensorDataForPlant(plantId: plantId, collectionRef: collection, documentId: documentId, sensorType: sensorType){}
            
            switch sensorType {
            case "heat":
                self.fetchedData = data.sunValues
            case "humidity":
                self.fetchedData =  data.humidityValues
            case "temperature":
                self.fetchedData =  data.temperatureValues
            case "moisture":
                self.fetchedData =  data.moistureValues
            case "timestamp":
                self.timestamps =  data.timestampValues
            default:
                break
            }
        data.fetchSensorDataForPlant(plantId: plantId, collectionRef: collection, documentId: documentId, sensorType: sensorType){}
        self.timestamps =  data.timestampValues
        
    }*/

    func makeUIViewController(context: Context) -> GraphPlot {
        return GraphPlot(plantId: plantId, collection: collection, documentId: documentId, sensorType: sensorType)
    }

    func updateUIViewController(_ uiViewController: GraphPlot, context: Context) {
    }
}

/*
 import Foundation
 import UIKit
 import TinyConstraints
 import DGCharts
 import SwiftUI

 class GraphPlot : UIViewController, ChartViewDelegate {
     
     @Published var selectedYValue = 0.0
     let datas: [Double]
     let timestamps: [Double]
     
     init(datas: [Double], timestamps: [Double]) {
         self.datas = datas
         self.timestamps = timestamps
         super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     lazy var lineChartView: LineChartView = {
         let chartView = LineChartView()
         chartView.rightAxis.enabled = false
         chartView.legend.enabled = false
         chartView.pinchZoomEnabled = true
         chartView.doubleTapToZoomEnabled = false
         let yAxis = chartView.leftAxis
         yAxis.labelTextColor = .black
         yAxis.axisLineColor = .white
         let xAxis = chartView.xAxis
         xAxis.enabled = false
         chartView.animate(xAxisDuration: 1.0)
         return chartView
     }()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         lineChartView.delegate = self
         view.addSubview(lineChartView)
         lineChartView.centerInSuperview()
         lineChartView.width(to: view)
         lineChartView.height(to: view)
         setData()
     }
     
     func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
         guard chartView == lineChartView else {
             return
         }
         selectedYValue = entry.y
         print("Y-Value: \(entry.y)")
     }
     
     func setData() {
         let set1 = LineChartDataSet(entries: values, label: "Test")
         set1.mode = .cubicBezier
         set1.lineWidth = 2
         set1.setColor(.black)
         set1.drawCirclesEnabled = false
         set1.highlightColor = .systemRed
         let data1 = LineChartData(dataSet: set1)
         data1.setDrawValues(false)
         lineChartView.data = data1
     }
     
     let values: [ChartDataEntry] = [
         ChartDataEntry(x:0, y: 1),
         ChartDataEntry(x: 0.1, y: 15),
         ChartDataEntry(x:0.2, y: 10),
         ChartDataEntry(x: 0.3, y: 15),
         ChartDataEntry(x:0.4, y: 10),
         ChartDataEntry(x: 0.5, y: 15),
         ChartDataEntry(x:0.6, y: 10),
         ChartDataEntry(x: 0.7, y: 15),
         ChartDataEntry(x: 0.8, y: 15),
         ChartDataEntry(x:0.9, y: 10),
         ChartDataEntry(x: 1.0, y: 15),
         ChartDataEntry(x:1.2, y: 50),
     ]
 }

 struct GraphPlotView: UIViewControllerRepresentable {
     var datas: [Double]
     var timestamps: [Double]
     var sensorType: String
     var plantId: String
     var collection: String
     var documentId: String

     init(plantId: String, collection: String, documentId: String, sensorType: String) {
         self.sensorType = sensorType
         self.plantId = plantId
         self.collection = collection
         self.documentId = documentId
         let data = GraphDataViewmodel()
         data.fetchSensorDataForPlant(plantId: plantId, collectionRef: collection, documentId: documentId, sensorType: sensorType) {
             self.datas = data.sensorValues(for: sensorType)
             self.timestamps = data.sensorValues(for: "timestamp")
             print(self.datas)
         }
     }

     func makeUIViewController(context: Context) -> GraphPlot {
         return GraphPlot(datas: datas, timestamps: timestamps)
     }

     func updateUIViewController(_ uiViewController: GraphPlot, context: Context) {
     }
 }

 
 */
