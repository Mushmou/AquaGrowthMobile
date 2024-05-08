//
//  support_view.swift
//  AquaGrowthMobile
//
//  Created by Megan Kang on 4/27/24.
//

//import Foundation
//import UIKit
//
//class SupportView: UIViewController{
//    
//    @IBOutlet weak var messageTextView: UITextView!
//    
//    let viewModel = support_viewmodel()
//    
//    override func viewDidLoad(){
//        super.viewDidLoad()
//    }
//    
//    @IBAction func sendButtonTapped(_ sender: UIButton){
//        guard let message = messageTextView.text, !message.isEmpty else{
//            return
//        }
//        viewModel.sendFeedback(message) {success in
//            if success {
//                print("Message sent successfully!")
//            }
//            else{
//                print("Failed to send message.")
//            }
//            
//        }
//    }
//    
//}

import SwiftUI
import MessageUI

struct SupportView: View {
    @State private var messageText = ""
    @StateObject private var viewModel = support_viewmodel()

    var body: some View {
        VStack {
            Text("Help and Support")
                .font(.largeTitle)
                .padding(.top, 20)
            
            Text("Have a question? Send us a message.")
                .font(.headline)
                .padding(.top, 10)
            
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
                    .background(Color.blue)
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




