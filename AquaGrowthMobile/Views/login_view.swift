//
//  login_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/28/24.
//

import Foundation
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

struct LoginView: View {
    @StateObject var google_viewModel = signIn_google_viewModel()
    @StateObject var viewModel = login_viewmodel()
    @State private var navigateBackToLogin = false
    //Environment object for the color scheme
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack{
            NavigationStack{
                Spacer()
                HStack{
                    Text("AquaGr")
                        .font(.system(size: 50))
                        .bold()
                    Text("🍅")
                        .font(.system(size: 40))
                        .padding(0)
                    Text("wth")
                        .font(.system(size: 50))
                        .bold()
                }
                
                VStack{
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .frame(width: 300, height: 65)
                        .background(Color.gray.opacity(0.20))
                        .cornerRadius(12)
                        .textInputAutocapitalization(.never)
                    
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .frame(width: 300, height: 65)
                        .background(Color.gray.opacity(0.20))
                        .cornerRadius(12)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5, anchor: .center)
                            .padding([.bottom,.top], 20)
                    } else {
                        Button("Log in") {
                            viewModel.login() // This should handle setting isLoading appropriately
                        }
                        .frame(width: 300, height: 65)
                        .background(Color(red: 0.28, green: 0.59, blue: 0.17))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                    }
                    
                    NavigationLink {
                        ForgotPasswordView()
                            .navigationBarBackButtonHidden(true)
                        
                    } label: {
                        Text("Forgot Password?")
                            .underline()
                            .bold()
                            .foregroundColor(Color(red: 0.28, green: 0.59, blue: 0.17))
                    }
                }.padding(.bottom, 50)
                
                Spacer()
                VStack{
                    
                    HStack {
                            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .icon, state: .normal)) {
                                google_viewModel.signInWithGoogle()
                            }
                                .clipShape(Circle()) // Clip the button to a circle shape
                                .shadow(radius: 4) // Optional: Add shadow to the button
                    }.padding(.bottom, 20)
                    
                    ZStack{
                        NavigationLink{
                            RegisterView()
                                .navigationBarBackButtonHidden(true)
                        }
                    label: {
                        Text("Sign up using Email Address")
                            .underline()
                            .bold()
                            .foregroundColor(Color(red: 0.28, green: 0.59, blue: 0.17))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
