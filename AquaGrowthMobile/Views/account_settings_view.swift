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
                
                VStack{
                    Spacer()
                    Text("Edit Profile")
                        .font(.system(size: 50))
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Username")
                        .font(.system(size: 24))
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: 360, alignment: .leading)
                        .padding(.top, 40)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(red: 0.94, green: 0.94, blue: 0.94))
                        .frame(width: 360, height: 65)
                        .overlay(
                            Text(" Username: \(viewModel.username)")
                                .frame(maxWidth: 345, alignment: .leading)
                        )
                    
                    Text("Email")
                        .font(.system(size: 24))
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: 360, alignment: .leading)
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(red: 0.94, green: 0.94, blue: 0.94))
                        .frame(width: 360, height: 65)
                        .overlay(
                            Text(" Email: \(viewModel.email)")
                                .frame(maxWidth: 345, alignment: .leading)
                        )
                    
                    Text("Password")
                        .font(.system(size: 24))
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: 360, alignment: .leading)
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(red: 0.94, green: 0.94, blue: 0.94))
                        .frame(width: 360, height: 65)
                        .overlay(
                            Text(" Password: \(viewModel.password)")
                                .frame(maxWidth: 345, alignment: .leading)
                        )
                    
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: 300, height: 65)
                        .foregroundColor(.red)
                        .overlay(
                            Button("Logout?") {
                                viewModel.logOut()
                            }
                                .foregroundColor(.white)
                                .font(.system(size: 25))
                        )
                        .padding(.top, 10)
                    Spacer()
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

#Preview{
    AccountView()
}


//    var body: some View {
//        Text("Enter your name")
//
//        RoundedRectangle(cornerRadius: 10)
//            .foregroundColor(Color(red: 0.94, green: 0.94, blue: 0.94))
//            .frame(width: 300, height: 65)
//            .overlay(
//                Text("Username: \(viewModel.username)")
//            )
//        RoundedRectangle(cornerRadius: 10)
//            .foregroundColor(Color(red: 0.94, green: 0.94, blue: 0.94))
//            .frame(width: 300, height: 65)
//
//            .overlay(
//                Text("Email: \(viewModel.email)")
//            )
//        RoundedRectangle(cornerRadius: 10)
//            .foregroundColor(Color(red: 0.94, green: 0.94, blue: 0.94))
//            .frame(width: 300, height: 65)
//
//            .overlay(
//                Text("Password: \(viewModel.password)")
//            )
//
//        RoundedRectangle(cornerRadius: 50)
//            .frame(width: 300, height: 65)
//            .foregroundColor(.red)
//            .overlay(
//                Button("Logout?") {
//                    viewModel.logOut()
//                }
//                    .foregroundColor(.white)
//                    .font(.system(size: 25))
//            )
//    }
