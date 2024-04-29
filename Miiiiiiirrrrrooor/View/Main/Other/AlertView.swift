//
//  AlertView.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI

struct AlertView: View {
    @EnvironmentObject internal var uiTheme: UITheme
    @EnvironmentObject internal var textTheme: TextTheme
    
    @State var toastText: String
    @State var opacity: CGFloat
    
    var body: some View {
        return Text(toastText)
            .foregroundStyle(textTheme.textColor)
            .background(
                RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                    .foregroundStyle(uiTheme.mainColor.opacity(opacity))
                    .padding(.all, -5)
            )
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    let textTheme = ThemePreview.WhitePreview.textTheme
    
    let opacity = CGFloat(0.5)
    
    return AlertView(toastText: "Hello", opacity: opacity)
        .environmentObject(uiTheme)
        .environmentObject(textTheme)
}
