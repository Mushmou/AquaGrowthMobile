import Foundation
import UIKit
import TinyConstraints //https://github.com/roberthein/TinyConstraints
import DGCharts //https://github.com/ChartsOrg/Charts
import SwiftUI


//used for framework
//https://www.youtube.com/watch?v=mWhwe_tLNE8&list=PL_csAAO9PQ8bjzg-wxEff1Fr0Y5W1hrum&index=5
//https://www.youtube.com/watch?v=csd7pyfEXgw

class GraphPlot : UIViewController, ChartViewDelegate {
    @ObservedObject var data = GraphDataViewmodel()
    var sensorType: String
    var plantId: String
    var dayweekmonthId:String
    var date:String
    
    @Published var selectedYValue = 0.0
    var xValues: [String] = []
    
    var fetchedData: [(Double,Double)] = []
    var days:[String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat","Sun"]
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
        //customize chart
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.pinchZoomEnabled = true
        chartView.doubleTapToZoomEnabled = false
        chartView.zoom(scaleX: 0.5, scaleY: 0.5, x: 0, y: 0)
        
        //customize y axis
        let yAxis = chartView.leftAxis
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .white
        //yAxis.setLabelCount(6, force: false)
        yAxis.labelPosition = .insideChart
       
        //customize x axis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.setLabelCount(7, force: true)
        //xAxis.labelRotationAngle = -25
        xAxis.labelFont = UIFont.systemFont(ofSize: 5)
        
        
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
        data.fetchGraphPoints(plantId: plantId, sensorType: sensorType, dayweekmonth: dayweekmonthId, date: date){
            
            switch self.sensorType {
            case "light":
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
                let dataEntry = ChartDataEntry(x: self.fetchedData[i].0, y: self.fetchedData[i].1)
                //let dataEntry = ChartDataEntry(x: self.xValues[i], y: self.fetchedData[i].1)
                //print(self.fetchedData[i].0, self.fetchedData[i].1)
                chartDataEntries.append(dataEntry)
            }
            
            
            let dataSet = LineChartDataSet(entries: chartDataEntries, label: "Data")
            //dataSet.mode = .horizontalBezier
            dataSet.lineWidth = 2
            dataSet.setColor(.black)
            dataSet.drawCirclesEnabled = false
            dataSet.highlightColor = .systemRed
            
            let data = LineChartData(dataSet: dataSet)
            data.setDrawValues(false)
            self.lineChartView.data = data
           
            
            // Set up x-axis labels
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let displayDateFormatter = DateFormatter()
            displayDateFormatter.dateFormat = "MMM dd"
            
            switch self.dayweekmonthId{
            case "day":
                self.xValues.removeAll()
                print()
            case "week":
                self.xValues.removeAll()
                self.data.getDaysInWeek(weekId: self.date)
                for day in self.data.allDaysInWeek {
                    guard let day = dateFormatter.date(from: day) else {
                        print("Error converting date")
                        continue
                    }
                    let dateString = displayDateFormatter.string(from: day)
                    self.xValues.append(dateString)
                }
                self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.xValues)
                
            case "month":
                self.xValues.removeAll()
                self.data.getWeeksInMonth()
                for week in self.data.allWeeksInMonth{
                    self.data.getDaysInWeek(weekId: week)
                    for day in self.data.allDaysInWeek{
                        if self.data.compareMonths(day: day, month: self.data.currentMonthId){
                            guard let day = dateFormatter.date(from: day) else {
                                print("Error converting date")
                                continue
                            }
                            let dateString = displayDateFormatter.string(from: day)
                            self.xValues.append(dateString)
                        }
                    }
                }
                self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.xValues)
                
            default:
                break
            }
        
            
        }
        
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

