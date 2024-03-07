//
//  profile_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 3/1/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
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
            }
        }
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .border(.red)
        .padding()
    }
}

#Preview {
    ProfileView()
}
