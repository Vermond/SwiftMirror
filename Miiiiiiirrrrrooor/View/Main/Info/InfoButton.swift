//
//  InfoButton.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI

struct InfoButton: View {
    @EnvironmentObject internal var uiTheme: UITheme
    
    @Binding var infoToggle: Bool
    
    var body: some View {
        Button(action: {
            infoToggle.toggle()
        }) {
            Image(systemName: "info.circle.fill")
                .scaleEffect(2.2)
                .foregroundStyle(uiTheme.mainImageButtonBackground)
                .frame(width: uiTheme.sizeUnit, height: uiTheme.sizeUnit)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(
            CircleOutline()
                .frame(maxWidth: .infinity, alignment: .trailing)
        )
    }
}

#Preview {
    let textTheme = ThemePreview.WhitePreview.textTheme
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    
    @State var toggle = true
    
    return InfoButton(infoToggle: $toggle)
        .padding(.horizontal, uiTheme.paddingUnit)
        .environmentObject(textTheme)
        .environmentObject(uiTheme)
}
