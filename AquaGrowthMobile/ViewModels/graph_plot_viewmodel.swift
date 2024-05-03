import Foundation
import UIKit
import TinyConstraints //https://github.com/roberthein/TinyConstraints
import DGCharts //https://github.com/ChartsOrg/Charts
import SwiftUI


//used for framework
//https://www.youtube.com/watch?v=mWhwe_tLNE8&list=PL_csAAO9PQ8bjzg-wxEff1Fr0Y5W1hrum&index=5

class GraphPlot : UIViewController, ChartViewDelegate {
    @ObservedObject var data = GraphDataViewmodel()
    var sensorType: String
    var plantId: String
    var dayweekmonthId:String
    var date:String
    
    @Published var selectedYValue = 0.0
    var xValues: [String] = []
    
    var fetchedData: [(Double,Double)] = []
    var timestamps: [Double] = []
    
    init(plantId: String, sensorType: String, dayweekmonthId:String, date:String) {
        self.sensorType = sensorType
        self.plantId = plantId
        self.dayweekmonthId = dayweekmonthId
        self.date = date
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
        //yAxis.setLabelCount(6, force: false)
        yAxis.labelPosition = .insideChart
        
        let xAxis = chartView.xAxis
        //xAxis.valueFormatter = IndexAxisValueFormatter(values: ["1","2","3","4","5"])
        xAxis.enabled = true
        xAxis.labelPosition = .bottom
        xAxis.setLabelCount(7, force: true)
        xAxis.valueFormatter = IndexAxisValueFormatter(values: self.xValues)
        
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
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard chartView == lineChartView else {
            return
        }
        selectedYValue = entry.y
        print("Y-Value: \(entry.y)")
    }
    
    
    func setData() {
        data.fetchGraphPoints(plantId: plantId, sensorType: sensorType, dayweekmonth: dayweekmonthId, date: date){
            
            switch self.sensorType {
            case "heat":
                self.fetchedData = self.data.sunGraphPoints
            case "humidity":
                self.fetchedData =  self.data.humidityGraphPoints
            case "temperature":
                self.fetchedData =  self.data.temperatureGraphPoints
            case "moisture":
                self.fetchedData =  self.data.moistureGraphPoints
            default:
                break
            }
            //print("fetchedaa",self.fetchedData)
            //print(self.fetchedData)
            //print(self.timestamps)
            // Check if fetchedData is empty
            
            guard !self.fetchedData.isEmpty else {
                print("Data is empty")
                return
            }
            
            var chartDataEntries: [ChartDataEntry] = []
            for i in 0...(self.fetchedData.count-1) {
                //let time = self.timestampToNumericValue(timestamp:self.timestamps[i])
                //print (self.fetchedData[i], time)
                let dataEntry = ChartDataEntry(x: self.fetchedData[i].0, y: self.fetchedData[i].1)
                //print(self.fetchedData[i].0, self.fetchedData[i].1)
                chartDataEntries.append(dataEntry)
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd" // Format for displaying dates, e.g., "Apr 29"
            
            for timestamp in  self.fetchedData{
                let date = Date(timeIntervalSince1970: timestamp.0)
                let dateString = dateFormatter.string(from: date)
                self.xValues.append(dateString)
                
            }
            
            
            let dataSet = LineChartDataSet(entries: chartDataEntries, label: "Test")
            //dataSet.mode = .horizontalBezier
            dataSet.lineWidth = 2
            dataSet.setColor(.black)
            dataSet.drawCirclesEnabled = false
            dataSet.highlightColor = .systemRed
            
            
            let data = LineChartData(dataSet: dataSet)
            data.setDrawValues(false)
            
            self.lineChartView.data = data
        }
        
    }
    func timestampToNumericValue(timestamp: TimeInterval) -> Double {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddHHmmssSSS"
        let dateString = dateFormatter.string(from: date)
        return Double(dateString) ?? 0.0
    }
    
}

struct GraphPlotView: UIViewControllerRepresentable {
    
    var sensorType: String
    var plantId: String
    var dayweekmonthId:String
    var date:String

    init(plantId: String, sensorType: String, dayweekmonthId:String, date:String) {
        self.sensorType = sensorType
        self.plantId = plantId
        self.dayweekmonthId = dayweekmonthId
        self.date = date
        
    }

    func makeUIViewController(context: Context) -> GraphPlot {
        return GraphPlot(plantId: plantId, sensorType: sensorType, dayweekmonthId: dayweekmonthId, date:date)
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
