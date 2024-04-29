//
//  CircleOutline.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI

struct CircleOutline: View {
    @EnvironmentObject internal var uiTheme: UITheme
    
    var body: some View {
        Circle()
            .stroke()
            .frame(width: uiTheme.sizeUnit)
            .foregroundStyle(uiTheme.mainColor)
    }
}

#Preview {
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    
    return CircleOutline()
        .frame(width: 100, height: 100)
        .environmentObject(uiTheme)
}
