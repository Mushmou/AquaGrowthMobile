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
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @State private var showNavigationBar = true

    var body: some View {
        VStack{
            ZStack{
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
                        .border(.red)
                }
                VStack {
                    Text("Help and Support")
                        .bold()
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .padding(.bottom, 100)
                    
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
            }.edgesIgnoringSafeArea(.all)
        }
    }

    func sendMessage() {
        viewModel.sendMessage(message: messageText)
    }
}

#Preview {
    SupportView()
}

