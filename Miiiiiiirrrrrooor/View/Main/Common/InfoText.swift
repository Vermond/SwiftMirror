//
//  InfoText.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI

struct InfoText: View {
    @EnvironmentObject internal var textTheme: TextTheme
    
    @State var text: String
    @State var maxWidth: CGFloat
    @State var unit: CGFloat
    
    var body: some View {
        Text(text)
            .frame(maxWidth: maxWidth, alignment: .trailing)
            .foregroundStyle(textTheme.textColor)
            .multilineTextAlignment(.trailing)
            .padding(.trailing, unit)
            .padding(.top, unit)
    }
}

#Preview {
    let textTheme = ThemePreview.WhitePreview.textTheme
    
    @State var text = "Hello world"
    @State var maxWidth: CGFloat = 100
    @State var unit: CGFloat = 1
    
    return InfoText(text: text, maxWidth: maxWidth, unit: unit)
        .environmentObject(textTheme)
}
