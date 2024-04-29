//
//  CurrentZoomButton.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI

struct CurrentZoomButton: View {
    @EnvironmentObject internal var uiTheme: UITheme
    @EnvironmentObject internal var textTheme: TextTheme
    
    @Binding var isZoomHidden: Bool
    @State var zoomRate: CGFloat
    
    var body: some View {
        Button(action: {
            isZoomHidden.toggle()
        }, label: {
            Text("x \(textTheme.numberToString(zoomRate))")
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
    
    @State var isZoomHidden = false
    let zoomRate = CGFloat(1)
    
    return CurrentZoomButton(isZoomHidden: $isZoomHidden, zoomRate: zoomRate)
        .environmentObject(uiTheme)
        .environmentObject(textTheme)
}
