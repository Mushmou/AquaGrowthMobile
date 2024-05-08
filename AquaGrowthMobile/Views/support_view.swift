//
//  support_view.swift
//  AquaGrowthMobile
//
//  Created by Megan Kang on 4/27/24.
//

import SwiftUI
import MessageUI

struct SupportView: View {
    @State private var messageText = ""
    @StateObject private var viewModel = support_viewmodel()

    var body: some View {
        VStack {
//            Rectangle()
//                .fill(Color(red: 0.28, green: 0.59, blue: 0.17))
//                .frame(width: UIScreen.main.bounds.width, height: 500) // Change the size of the VStack
//                .position(x: UIScreen.main.bounds.width / 2.179, y: 10)
//            
////            Rectangle()
////                .fill(.white)
////                .frame(width: UIScreen.main.bounds.width, height: 640) // Change the size of the VStack
////                .position(x: UIScreen.main.bounds.width / 2, y: 550)
            
//            Text("Help & Support")
//                .font(.system(size: 45))
//                .bold()
//                .padding(.top, 20)
//                .position(x: UIScreen.main.bounds.width / 2.179, y: -25)
//                .foregroundColor(.white)
            Text("Help and Support")
                .bold()
                .font(.largeTitle)
                .padding(.top, 20)
            
            Text("Have a question? Send us a message.")
                .font(.headline)
                .padding(.top, 20)
            
            TextEditor(text: $messageText)
                .frame(height: 150)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            Button(action: {
                sendMessage()
            }, label: {
                Text("Send")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.28, green: 0.59, blue: 0.17))
                    .cornerRadius(10)
                    .padding(.horizontal)
            })
            .padding(.top, 20)
        }
        .padding(.horizontal)
        .navigationBarTitle("Support", displayMode: .inline)
        .alert(isPresented: $viewModel.showingMailAlert) {
            Alert(title: Text(viewModel.mailAlertTitle), message: Text(viewModel.mailAlertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func sendMessage() {
        viewModel.sendMessage(message: messageText)
    }
}

#Preview {
    SupportView()
}
