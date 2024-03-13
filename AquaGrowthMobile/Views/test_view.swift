//
//  test_view.swift
//  AquaGrowthMobile
//
//  Created by Jeet Patel on 3/13/24.
//

import Foundation
import SwiftUI

struct TestView : View{
    @EnvironmentObject var bluetooth: bluetooth_viewmodel

       var body: some View {
           let my_peripheral = bluetooth.bluetoothModel.connectedPeripheral
            VStack {
                Text("Plant View")
                if my_peripheral != nil{
                    Text("Status: \(bluetooth.bluetoothModel.connectedPeripheral!)")
                }
                if bluetooth.bluetoothModel.ledCharacteristicValue != nil{
                    Text("Value: \(bluetooth.bluetoothModel.ledCharacteristicValue!)")
                }
                Button("Read LED Characteristic") {
                    if (my_peripheral != nil) {
                        bluetooth.readLEDCharacteristic()
                    }
                }
                
                if bluetooth.bluetoothModel.moistureCharacteristicValue != nil{
                    Text("Value: \(bluetooth.bluetoothModel.moistureCharacteristicValue!)")
                }
                Button("Read Moisture Characteristic") {
                    if (my_peripheral != nil) {
                        bluetooth.readMoistureCharacteristic()
                    }
                }
                if let humidityValueHex = bluetooth.bluetoothModel.humidityCharacteristicValue {
                    let humidity = bluetooth.convertHexToDecimal(hexString: humidityValueHex)
                    Text("Value: \(humidity)")
                } else {
                    Text("Humidity data not available")
                }
                
                Button("Read Humidity Characteristic") {
                    if (my_peripheral != nil) {
                        bluetooth.readHumidityCharacteristic  ()
                    }
                }
                if bluetooth.bluetoothModel.fahrenheitCharacteristicValue != nil{
                    Text("Value: \(bluetooth.bluetoothModel.fahrenheitCharacteristicValue!)")
                }
                Button("Read Fahrenheit Characteristic") {
                    if (my_peripheral != nil) {
                        bluetooth.readFahrenheitCharacteristic()
                    }
                }
                if bluetooth.bluetoothModel.heatIndexCharacteristicValue != nil{
                    Text("Value: \(bluetooth.bluetoothModel.heatIndexCharacteristicValue!)")
                }
                Button("Read Heat Index Characteristic") {
                    if (my_peripheral != nil) {
                        bluetooth.readHeatIndexCharacteristic()
                    }
                }
            }
        }
    }




