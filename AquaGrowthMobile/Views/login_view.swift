//
//  login_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI


struct LoginView: View {
    @StateObject var viewModel = login_viewmodel()
    @State private var navigateBackToLogin = false

    var body: some View {
        VStack{
            NavigationStack{
                Spacer()
                Text("AquaGr🍅wth")
                    .font(.system(size: 60))
                    .bold()
//                    .border(.red)
                
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .frame(width: 300, height: 65)
                    .background(.gray.opacity(0.10))
                    .cornerRadius(12)
                    .textInputAutocapitalization(.never)
                
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .frame(width: 300, height: 65)
                    .background(.gray.opacity(0.10))
                    .cornerRadius(12)
                
                Button("Log in"){
                    viewModel.login()
                }
                .frame(width: 300, height: 65)
                .background(Color(red: 0.28, green: 0.59, blue: 0.17))
                .cornerRadius(12)
                .foregroundColor(.white)
                
                NavigationLink {
                    ForgotPasswordView()
                        .navigationBarBackButtonHidden(true)

                } label: {
                    Text("Forgot Password?")
                        .underline()
                        .foregroundColor(.black)
                }
//                .border(.red)
                Spacer()
                Text("Don't have an account?")
                NavigationLink {
                    RegisterView()
                        .navigationBarBackButtonHidden(true)
                        .toolbar{
                            ToolbarItem(placement: .navigationBarLeading) {
                                NavigationLink {
                                    LoginView()
                                    .navigationBarBackButtonHidden(true)
                                } label: {
                                    // 4
                                    Image(systemName: "chevron.backward")
                                        .font(.system(size: 30)) // Adjust the size as needed
                                        .foregroundColor(.black)
                                }
                            }
                        }
                } label: {
                    Text("Sign up for AquaGrowth")
                        .underline()
                        .bold()
                        .foregroundColor(Color(red: 0.28, green: 0.59, blue: 0.17))
                }
//                .border(.red)
            }
        }
//        .border(.red)
    }
}

#Preview {
    LoginView()
}
