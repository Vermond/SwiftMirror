//
//  ZoomText.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI

struct ZoomText: View {
    @EnvironmentObject internal var uiTheme: UITheme
    @EnvironmentObject internal var textTheme: TextTheme
    
    @State var text: String
    
    var body: some View {
        Text(text)
            .foregroundStyle(textTheme.textColor)
            .frame(width: uiTheme.sizeUnit, height: uiTheme.sizeUnit)
            .background(
                RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                    .foregroundStyle(uiTheme.mainColor.opacity(uiTheme.imageButtonOpacity * 0.5))
                    .padding(.horizontal, -10)
            )
    }
}

#Preview {
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    let textTheme = ThemePreview.WhitePreview.textTheme
    
    let text = "x1"
    
    return ZoomText(text: text)
        .environmentObject(uiTheme)
        .environmentObject(textTheme)
}
