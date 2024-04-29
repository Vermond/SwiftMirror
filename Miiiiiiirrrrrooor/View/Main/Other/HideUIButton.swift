//
//  HideUIButton.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI

struct HideUIButton: View {
    @EnvironmentObject internal var uiTheme: UITheme
    @EnvironmentObject internal var textTheme: TextTheme
    
    @Binding var isUIHidden: Bool
    
    var body: some View {
        Button(action: {
            isUIHidden = true
        }, label: {
            Text("Hide UI")
                .scaleEffect(textTheme.textScaleRate)
                .foregroundStyle(textTheme.textColor)
                .frame(width: uiTheme.sizeUnit * 1.75, height: uiTheme.sizeUnit)
        })
        .background(SquareButton())
    }
}

#Preview {
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    let textTheme = ThemePreview.WhitePreview.textTheme
    
    @State var isUIHidden = false
    
    return HideUIButton(isUIHidden: $isUIHidden)
        .environmentObject(uiTheme)
        .environmentObject(textTheme)
}
