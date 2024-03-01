//
//  register_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI



extension View {
    func customTextFieldStyle() -> some View {
        self
            .padding()
            .frame(width: 300, height: 65)
            .background(Color.gray.opacity(0.10))
            .cornerRadius(12)
    }
}

struct RegisterView: View {
    @StateObject var viewModel = register_viewmodel()

    var body: some View {
        VStack{
            Text("Glad you're branching out with us. 🌳")
                .font(.system(size: 60))
                .bold()
                .multilineTextAlignment(.center)

            TextField("Username", text: $viewModel.username)
                .customTextFieldStyle()
                .textInputAutocapitalization(.never)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 12)
//                        .strokeBorder(viewModel.isUsernameValid ? Color.clear : Color.red, lineWidth: 2)
//                )
            TextField("Email", text: $viewModel.email)
                .customTextFieldStyle()
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $viewModel.password)
                .customTextFieldStyle()
            SecureField("Confirm Password", text: $viewModel.confirm_password)
                .customTextFieldStyle()
            Button("Create Account"){
                viewModel.register()
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
