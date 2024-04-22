//
//  bluetooth_viewmodel.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI
import CoreBluetooth
//
//// THIS IS WHERE IM DECLARING THE PERIPHERAL CODE
//
////Initialize the Bluetooth View Model as an observable object (this changes the objects state)
class bluetooth_viewmodel: NSObject, ObservableObject, CBPeripheralDelegate {
    //Central manager object
    private var centralManager: CBCentralManager?
    @Published var bluetoothModel = BluetoothModel()
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    //Function to add peripheral to central manager
    func connect(peripheral: CBPeripheral) {
        centralManager?.connect(peripheral)
    }
    
    //Function to remove peripheral from central manager
    func disconnect(peripheral: CBPeripheral) {
        centralManager?.cancelPeripheralConnection(peripheral)
    }
    
    
    // Call after connecting to peripheral
    func discoverServices(peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    // Call after discovering services
    func discoverCharacteristics(peripheral: CBPeripheral) {
        guard let services = peripheral.services else {
            return
        }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    //Call to read the value of characteristic
    func readValue(characteristic: CBCharacteristic) {
        bluetoothModel.connectedPeripheral?.readValue(for: characteristic)
    }
    
    
    func readLEDCharacteristic() {
        print("Reading LED characteristic")
        
        // Check if the connectedPeripheral is valid
        guard let peripheral = bluetoothModel.connectedPeripheral else {
            print("Connected peripheral is nil")
            return
        }
        
        // Check if the peripheral is connected
        guard peripheral.state == .connected else {
            print("Peripheral is not connected")
            return
        }
        
        for c in bluetoothModel.discoveredCharacteristics{
            if c.uuid == CBUUID(string: "759c8d51-2f75-4041-9ed8-c920c06cdbd0") {
                readValue(characteristic: c)
            }
        }
    }
    
    func readMoistureCharacteristic(){
        print("Reading moisture characteristic")
        // Check if the connectedPeripheral is valid
        guard let peripheral = bluetoothModel.connectedPeripheral else {
            print("Connected peripheral is nil")
            return
        }
        
        // Check if the peripheral is connected
        guard peripheral.state == .connected else {
            print("Peripheral is not connected")
            return
        }
        
        for c in bluetoothModel.discoveredCharacteristics{
            if c.uuid == CBUUID(string: "db4e8f1c-4a29-4a15-bc6d-cb4d1180cf46"){
                readValue(characteristic: c)
            }
        }
    }
    
    func readHumidityCharacteristic(){
        print("Reading humidity characteristic")
        // Check if the connectedPeripheral is valid
        guard let peripheral = bluetoothModel.connectedPeripheral else {
            print("Connected peripheral is nil")
            return
        }
        
        // Check if the peripheral is connected
        guard peripheral.state == .connected else {
            print("Peripheral is not connected")
            return
        }
        
        for c in bluetoothModel.discoveredCharacteristics{
            if c.uuid == CBUUID(string: "f691c6b2-73f3-4743-a344-1eeca53ab9eb"){
                readValue(characteristic: c)
            }
        }
    }
    
    func readFahrenheitCharacteristic(){
        print("Reading fahrenheit characteristic")
        // Check if the connectedPeripheral is valid
        guard let peripheral = bluetoothModel.connectedPeripheral else {
            print("Connected peripheral is nil")
            return
        }
        
        // Check if the peripheral is connected
        guard peripheral.state == .connected else {
            print("Peripheral is not connected")
            return
        }
        
        for c in bluetoothModel.discoveredCharacteristics{
            if c.uuid == CBUUID(string: "0c1c7c47-b159-4e19-9d0f-f5f717445549"){
                readValue(characteristic: c)
            }
        }
    }
    
    func readHeatIndexCharacteristic(){
        print("Reading heat index characteristic")
        // Check if the connectedPeripheral is valid
        guard let peripheral = bluetoothModel.connectedPeripheral else {
            print("Connected peripheral is nil")
            return
        }
        
        // Check if the peripheral is connected
        guard peripheral.state == .connected else {
            print("Peripheral is not connected")
            return
        }
        
        for c in bluetoothModel.discoveredCharacteristics{
            if c.uuid == CBUUID(string: "5be60d98-5e69-4863-96a1-28a46cf73536"){
                readValue(characteristic: c)
            }
        }
    }
    // Update characteristic values in the BluetoothModel
    private func updateCharacteristicValue(characteristic: CBCharacteristic, value: Data?) {
        switch characteristic.uuid {
        case CBUUID(string: "759c8d51-2f75-4041-9ed8-c920c06cdbd0"):
            bluetoothModel.ledCharacteristicValue = value
        case CBUUID(string: "db4e8f1c-4a29-4a15-bc6d-cb4d1180cf46"):
            bluetoothModel.moistureCharacteristicValue = value
        case CBUUID(string: "f691c6b2-73f3-4743-a344-1eeca53ab9eb"):
            bluetoothModel.humidityCharacteristicValue = value
        case CBUUID(string: "0c1c7c47-b159-4e19-9d0f-f5f717445549"):
            bluetoothModel.fahrenheitCharacteristicValue = value
        case CBUUID(string: "5be60d98-5e69-4863-96a1-28a46cf73536"):
            bluetoothModel.heatIndexCharacteristicValue = value
        default:
            break
        }
    }
}


extension bluetooth_viewmodel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //TODO Add switch case for each state in the "central.state" in central manager
        // If state is ON then scan for nearby peripherals.
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    // Adds the discovered peripherals into an array "discoveredPeripherals"
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !bluetoothModel.discoveredPeripherals.contains(peripheral) {
            bluetoothModel.discoveredPeripherals.append(peripheral)
        }
    }
    
    //Connect peripheral state
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        bluetoothModel.connectedPeripheral = peripheral
        bluetoothModel.isConnected = true
        print("connected peripheral is", bluetoothModel.connectedPeripheral)
        peripheral.delegate = self
        discoverServices(peripheral: peripheral)
    }
    
    //Failed peripheral state
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        // Handle error
    }
    
    //Disconnect peripheral
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            // Handle error
            return
        }
        // Successfully disconnected
        bluetoothModel.isConnected = false
    }
    
    // Discover services callback
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        discoverCharacteristics(peripheral: peripheral)
    }
    
    // Discover characteristics callback
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        print("Did discover characteristics for service: \(service.uuid)")
        guard let characteristics = service.characteristics else {
            return
        }
        print("characteristics: \(characteristics)")
        
        // I stored the characteristics inside of an array to save us from rediscovering characteristics again?
        bluetoothModel.discoveredCharacteristics += characteristics

        // Consider storing important characteristics internally for easy access and equivalency checks later.
        // From here, can read/write to characteristics or subscribe to notifications as desired.
    }
    
    
    // This handles an updated value for the characteristic
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            // Handle error
            return
        }
        guard let value = characteristic.value else {
            return
        }
        print("update")
        updateCharacteristicValue(characteristic: characteristic, value: value)
        print("Updated value for characteristic: \(characteristic.uuid), Value: \(value)")
        
    }
}
