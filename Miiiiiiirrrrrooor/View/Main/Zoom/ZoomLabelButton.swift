//
//  ZoomLabelButton.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI

struct ZoomLabelButton: View {
    @EnvironmentObject internal var textTheme: TextTheme
    
    @State var zoomRate: CGFloat
    @State var callback: (CGFloat) -> Void
    
    var body: some View {
        Button(action: {
            callback(zoomRate)
        }, label: {
            ZoomText(text: "x\(textTheme.numberToString(zoomRate))")
        })
    }
}

#Preview {
    let textTheme = ThemePreview.WhitePreview.textTheme
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    
    let zoomRate = CGFloat(1)
    
    return ZoomLabelButton(zoomRate: zoomRate) { value in }
        .environmentObject(textTheme)
        .environmentObject(uiTheme)
}
