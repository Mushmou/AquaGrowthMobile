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
                if bluetooth.bluetoothModel.ledCharacteristicInt != nil{
                    Text("Value: \(bluetooth.bluetoothModel.ledCharacteristicInt!)")
                }
                Button("Read LED Characteristic") {
                    if (my_peripheral != nil) {
                        bluetooth.readLEDCharacteristic()
                    }
                }
                
                if bluetooth.bluetoothModel.moistureCharacteristicInt != nil{
                    Text("Value: \(bluetooth.bluetoothModel.moistureCharacteristicInt!)")
                }
                Button("Read Moisture Characteristic") {
                    if (my_peripheral != nil) {
                        bluetooth.readMoistureCharacteristic()
                    }
                }
                if bluetooth.bluetoothModel.humidityCharacteristicInt != nil{
                    Text("Value: \(bluetooth.bluetoothModel.humidityCharacteristicInt!)")
                }
                
                Button("Read Humidity Characteristic") {
                    if (my_peripheral != nil) {
                        bluetooth.readHumidityCharacteristic  ()
                    }
                }
                if bluetooth.bluetoothModel.fahrenheitCharacteristicInt != nil{
                    Text("Value: \(bluetooth.bluetoothModel.fahrenheitCharacteristicInt!)")
                }
                Button("Read Fahrenheit Characteristic") {
                    if (my_peripheral != nil) {
                        bluetooth.readFahrenheitCharacteristic()
                    }
                }
                if bluetooth.bluetoothModel.heatIndexCharacteristicInt != nil{
                    Text("Value: \(bluetooth.bluetoothModel.heatIndexCharacteristicInt!)")
                }
                Button("Read Heat Index Characteristic") {
                    if (my_peripheral != nil) {
                        bluetooth.readHeatIndexCharacteristic()
                    }
                }
                
                if bluetooth.bluetoothModel.lightCharacteristicInt != nil{
                    Text("Value: \(bluetooth.bluetoothModel.lightCharacteristicInt!)")
                }
                Button("Read Light Index Characteristic") {
                    if (my_peripheral != nil) {
                        bluetooth.readLightCharacteristic()
                    }
                }
            }
        }
    }




