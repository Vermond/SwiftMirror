//
//  SquareButton.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI

struct SquareButton: View {
    @EnvironmentObject internal var uiTheme: UITheme
    
    var body: some View {
        RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
            .stroke()
            .foregroundStyle(uiTheme.mainColor)
            .background(
                RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                    .foregroundStyle(uiTheme.mainImageButtonBackground)
            )
    }
}

#Preview {
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    
    return SquareButton()
        .frame(width: 100, height: 100)
        .environmentObject(uiTheme)
}
