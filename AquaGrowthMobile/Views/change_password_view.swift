//
//  change_password_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject var viewModel: forgot_password_viewmodel

    var body: some View {
        VStack {
            Spacer()
            Text("Reset email has been sent! \n Check email for instructions.")
            .font(.system(size: 25))
            .bold()
            .multilineTextAlignment(.center)
            .border(.red)
            
            Button("Send Again"){
                viewModel.reset()
            }
            .frame(width: 300, height: 65)
            .background(Color(red: 0.28, green: 0.59, blue: 0.17))
            .cornerRadius(10)
            .foregroundColor(.white)
            
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
            .border(.red)
        }
    }
}

#Preview {
    ChangePasswordView()
        .environmentObject(forgot_password_viewmodel())
}
