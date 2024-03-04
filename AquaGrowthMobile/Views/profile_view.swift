//
//  profile_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 3/1/24.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    var body: some View {
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
