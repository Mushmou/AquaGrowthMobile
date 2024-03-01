//
//  register_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = register_viewmodel()

    var body: some View {
        VStack{
            Text("Glad you're branching out with us. 🌳")
                .font(.system(size: 60))
                .bold()
                .multilineTextAlignment(.center)

            TextField("Username", text: $viewModel.username)
                .padding()
                .frame(width: 300, height: 65)
                .background(.gray.opacity(0.10))
                .cornerRadius(12)
                .textInputAutocapitalization(.never)
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
            SecureField("Confirm Password", text: $viewModel.confirm_password)
                .padding()
                .frame(width: 300, height: 65)
                .background(.gray.opacity(0.10))
                .cornerRadius(12)
            Button("Create Account"){
                //Create your account
            }
            .frame(width: 300, height: 65)
            .background(Color(red: 0.28, green: 0.59, blue: 0.17))
            .cornerRadius(12)
            .foregroundColor(.white)
        }
    }
}

#Preview {
    RegisterView()
}
