//
//  bluetooth_model.swift
//  AquaGrowthMobile
//

//  Created by Noah Jacinto on 2/28/24.


import Foundation
import Foundation
import CoreBluetooth

struct BluetoothModel {
    var discoveredPeripherals: [CBPeripheral] = []
    var connectedPeripheral: CBPeripheral?
    var discoveredCharacteristics: [CBCharacteristic] = []
    var ledCharacteristicValue: Data?
    var moistureCharacteristicValue: Data?
    var humidityCharacteristicValue: Data?
    var fahrenheitCharacteristicValue: Data?
    var heatIndexCharacteristicValue: Data?
    var ledCharacteristicInt: Int?
    var moistureCharacteristicInt: Int?
    var humidityCharacteristicInt: Int?
    var fahrenheitCharacteristicInt: Int?
    var heatIndexCharacteristicInt: Int?
    var isConnected: Bool = false
}
