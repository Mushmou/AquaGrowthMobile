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

import Firebase
import AuthenticationServices
import CryptoKit
struct LoginView: View {
    //Viewmodels for Google and Login Backend
    @StateObject var google_viewModel = signIn_google_viewModel()
    @StateObject var viewModel = login_viewmodel()

    @State private var nonce: String?
    //Color scheme for dark and light mode
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack{
            NavigationStack{
                Spacer()
                
                //Title for Logo
                //TODO: Replace this set of HStack with an image of our logo.
                HStack{
                    Text("AquaGr")
                        .font(.system(size: 55))
                        .bold()
                    Text("🍅")
                        .font(.system(size: 40))
                        .padding(0)
                    Text("wth")
                        .font(.system(size: 55))
                        .bold()
                }
                .padding(.bottom, 80)
                
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
                    
                    //Starts loading icon, then waits to submit the login function using Email and Password.
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
                    //Field for ForgotPassword
                    
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
                    VStack{
                        HStack {
                            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .icon, state: .normal)) {
                                google_viewModel.signInWithGoogle()
                            }
                            .clipShape(Circle()) // Set the button into a circle shape. It was originally a rectangle.
                            .shadow(radius: 4) // Adds a shadow to the button.
                        }
                        .padding(.bottom, 20) //Set padding below the Google Icon
                        
                        //Adding Sign in With Apple Button Here
                            
                        SignInWithAppleButton(.signIn) { request in
                            
                            let nonce = randomNonceString()
                            self.nonce = nonce
                            request.requestedScopes = [.email, .fullName]
                            request.nonce = sha256(nonce)
                        } onCompletion: { result in
                            switch result {
                            case .success(let authorization):
                                signInWithApple(authorization)
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                            // Do something
                        }
                        .frame(width: 200, height: 45)
                        .clipShape(.capsule)
                        .padding(.top, 10)

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

    func signInWithApple(_ authorization: ASAuthorization ){
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce else {
                print("Invalid state: A login callback was received, but no login request was sent.")
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    return
                }
                // User is signed in to Firebase with Apple.
            }
        }
    }
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

#Preview {
    LoginView()
}
