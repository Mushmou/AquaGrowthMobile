//
//  forgot_password_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI


struct ForgotPasswordView: View {
    @StateObject var viewModel = forgot_password_viewmodel()
    @State private var navigateToChangePasswordView = false

    var body: some View {
        VStack{
            NavigationStack{
                Spacer()
                Text("Forgot password?")
                    .font(.system(size: 50))
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40)
//                    .border(.red)
                
                TextField("Email Address", text: $viewModel.email)
                    .padding()
                    .frame(width: 300, height: 65)
                    .background(.gray.opacity(0.10))
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                
                Button("Continue") {
                    viewModel.reset() // Run code to send reset email
                    navigateToChangePasswordView = true // Activate NavigationLink
                }
                .frame(width: 300, height: 65)
                .background(Color(red: 0.28, green: 0.59, blue: 0.17))
                .cornerRadius(10)
                .foregroundColor(.white)
                
                NavigationLink(
                    destination: ChangePasswordView()
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(viewModel), // Pass viewModel to ChangePasswordView
                    isActive: $navigateToChangePasswordView
                ) {
                    EmptyView()
                }
                .hidden()

                Spacer()
                Text("Already have an account?")
                NavigationLink {
                    LoginView()
                    .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Log In")
                        .underline()
                        .bold()
                        .foregroundColor(Color(red: 0.28, green: 0.59, blue: 0.17))
                }
//                .border(.red)
            }
        }
    }
    
}

#Preview {
    ForgotPasswordView()
}
