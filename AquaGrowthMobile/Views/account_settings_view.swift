//
//  account_settings_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI

struct AccountView: View {
    @StateObject var viewModel = account_settings_viewmodel()
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    @State private var showNavigationBar = true
    
    var body: some View {
        VStack {
            ZStack{
                //This code creates the back button
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
                    
                    ZStack{
                        Rectangle()
                            .fill(Color(red: 0.28, green: 0.59, blue: 0.17))
                            .frame(maxWidth: .infinity, maxHeight: 300)
                        VStack{
                            Text("Edit Profile")
                                .font(.system(size: 50))
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    ZStack{
                        Rectangle()
                            .fill(Color.white)
                            .frame(maxWidth: .infinity)
                        
                        VStack{
                            Spacer()
                            
                            Text("Username")
                                .font(.system(size: 24))
                                .bold()
                                .foregroundColor(.black)
                                .frame(maxWidth: 360, alignment: .leading)
                            TextField("Username", text: $viewModel.username)
                                .padding()
                                .frame(width: 360, height: 65)
                                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                                .cornerRadius(12)
                                .textInputAutocapitalization(.never)
                            
                            Text("Email")
                                .font(.system(size: 24))
                                .bold()
                                .foregroundColor(.black)
                                .frame(maxWidth: 360, alignment: .leading)
                            TextField("Email", text: $viewModel.email)
                                .padding()
                                .frame(width: 360, height: 65)
                                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                                .cornerRadius(12)
                                .textInputAutocapitalization(.never)
                            
                            Text("Password")
                                .font(.system(size: 24))
                                .bold()
                                .foregroundColor(.black)
                                .frame(maxWidth: 360, alignment: .leading)
                            
                            SecureField("Enter new password", text: $viewModel.password)
                                .padding()
                                .frame(width: 360, height: 65)
                                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                                .cornerRadius(12)
                                .textInputAutocapitalization(.never)
                            
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: 300, height: 65)
                                .foregroundColor(Color(red: 0.28, green: 0.59, blue: 0.17))
                                .overlay(
                                    Button("Submit") {
                                        //Submit all the new data
                                    }
                                        .foregroundColor(.white)
                                        .font(.system(size: 25))
                                )
                                .padding(.top, 10)
                            Spacer()
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(){
            viewModel.getUserEmail()
            viewModel.getUsername()
        }
    }
}

#Preview{
    AccountView()
}
