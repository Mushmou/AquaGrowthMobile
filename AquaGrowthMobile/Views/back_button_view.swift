//
//  back_button_view.swift
//  AquaGrowthMobile
//
//  Created by Noah Jacinto on 2/29/24.
//

import SwiftUI

struct BackButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.backward")
                .font(.title)
        }
        .symbolVariant(.circle.fill)
    }
}

#if DEBUG
struct BackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BackButtonView(action: {})
    }
}
#endif
