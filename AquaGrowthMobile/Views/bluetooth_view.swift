//
//  bluetooth_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI

struct BluetoothView: View {
    @ObservedObject var viewModel = bluetooth_viewmodel()
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color(red: 0.28, green: 0.59, blue: 0.17))
                .frame(width: 400, height: 300) // Change the size of the VStack
                .position(x: UIScreen.main.bounds.width / 2, y: 80)
            
            Rectangle()
                .fill(.white)
                .frame(width: 400, height: 640) // Change the size of the VStack
                .position(x: UIScreen.main.bounds.width / 2, y: 550)
            
            Text("Nearby Devices")
                .font(.system(size: 50))
                .bold()
                .position(x: UIScreen.main.bounds.width / 2, y: 70)
                .foregroundColor(.white)

            VStack {
//                List(viewModel.bluetoothModel.discoveredPeripherals, id: \.self) { peripheral in

                List(viewModel.bluetoothModel.discoveredPeripherals.filter { $0.name == "DREOtf05s10" }, id: \.self) { peripheral in
                    HStack {
                        Text(peripheral.name ?? "Unknown Device")
                            .bold()
                        Spacer()
                        
                        if viewModel.bluetoothModel.connectedPeripheral == peripheral && viewModel.bluetoothModel.isConnected {
                            Button("Disconnect") {
                                viewModel.disconnect(peripheral: peripheral)
                            }
                            .tint(.red)
                            .bold()
                        } else {
                            Button("Connect") {
                                viewModel.connect(peripheral: peripheral)
                            }
                            .tint(.green)
                            .bold()
                        }
                    }
                    .padding(15)
                    .cornerRadius(20.0)

                }
                .frame(width: 360, height: 415) // Change the size of the List
            }
            .cornerRadius(50.0)
            
            RoundedRectangle(cornerRadius: 50)
                .frame(width: 300, height: 65)
                .foregroundColor(Color(red: 0.28, green: 0.59, blue: 0.17))
                .overlay(
                    Button("Can't find device?") {
                        // Action for the button
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                )
                .position(x: UIScreen.main.bounds.width / 2, y: 700)
        }
    }
}


#Preview {
    BluetoothView()
}
