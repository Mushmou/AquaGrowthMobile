import Foundation
import SwiftUI

struct BluetoothView: View {
    @EnvironmentObject var viewModel: bluetooth_viewmodel
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @State private var showNavigationBar = true
    
    var body: some View {
        NavigationStack{
            VStack {
                ZStack {
                    Color.clear.frame(width: 1, height:1)
                        .navigationBarBackButtonHidden(true)
                        .toolbar{
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button (action: {
                                    presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Image(systemName: "chevron.backward")
                                        .font(.system(size: 30)) // Adjust the size as needed
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                })
                                .onTapGesture {
                                    withAnimation {
                                        showNavigationBar.toggle()
                                    }
                                }
                            }
                        }
                    
                    VStack{
                        Rectangle()
                            .fill(Color(red: 0.28, green: 0.59, blue: 0.17))
                            .frame(maxWidth: .infinity, maxHeight: 300)
                        
                        Spacer(minLength: 0)
                        Rectangle()
                            .fill(Color.white)
                            .frame(maxWidth: .infinity)
                    }
                    
                    VStack{
                        Spacer()
                        Text("Settings")
                            .font(.system(size: 50))
                            .bold()
                            .foregroundColor(.white)
                        
                        Spacer()
                        List(viewModel.bluetoothModel.discoveredPeripherals.filter { $0.name == "AquaGrowth" }, id: \.self) { peripheral in
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
                        .cornerRadius(20.0)
                        
                        Spacer()
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
                        
                        Spacer()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// Preview provider for SwiftUI previews in Xcode
struct BluetoothView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothView().environmentObject(bluetooth_viewmodel())
    }
}
