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
    
    var body: some View {
        
        VStack{
            Spacer()
            Text("AquaGrowth")
                .font(.system(size: 50))
            
            TextField("Email", text: $viewModel.email)
                .padding()
                .frame(width: 300, height: 65)
                .background(.gray.opacity(0.10))
                .cornerRadius(10)
                .textInputAutocapitalization(.never)


            SecureField("Password", text: $viewModel.password)
                .padding()
                .frame(width: 300, height: 65)
                .background(.gray.opacity(0.10))
                .cornerRadius(10)
            
            Button("Log in"){
                viewModel.login()
            }
                .frame(width: 300, height: 65)
                .background(.green.opacity(1))
                .cornerRadius(10)
                .foregroundColor(.white)
            
            Button("Forgot Password?"){
                // Do something
            }
            Spacer()
            VStack{
                Text("Don't have an account?")
                NavigationLink("Sign up for AquaGrowth", destination: RegisterView())
            }
        }
    }
}

#Preview {
    LoginView()
}
