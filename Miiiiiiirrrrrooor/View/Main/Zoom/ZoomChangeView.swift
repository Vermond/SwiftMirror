//
//  ZoomChangeView.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI

struct ZoomChangeView: View {
    @EnvironmentObject internal var uiTheme: UITheme
    
    @Binding var zoomRate: CGFloat
    @State var zoomRange: ClosedRange<CGFloat>
    @State var callback: (CGFloat) -> Void
    
    var body: some View {
        HStack {
            VerticalSliderView(value: $zoomRate, valueRange: zoomRange)
                .frame(width: uiTheme.sizeUnit, height: uiTheme.sizeUnit * 5)
            
            VStack {
                ZoomLabelButton(zoomRate: zoomRange.upperBound) { rate in callback(rate)}
                Spacer()
                ZoomLabelButton(zoomRate: zoomRange.middleBound) { rate in callback(rate)}
                Spacer()
                ZoomLabelButton(zoomRate: zoomRange.lowerBound) { rate in callback(rate)}
            }
            .frame(height: uiTheme.sizeUnit * 5)
        }
    }
}

#Preview {
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    let textTheme = ThemePreview.WhitePreview.textTheme
    
    @State var zoomRate = CGFloat(1)
    @State var zoomRange: ClosedRange<CGFloat> = 1...3
    
    return ZoomChangeView(zoomRate: $zoomRate, zoomRange: zoomRange) { rate in }
        .environmentObject(uiTheme)
        .environmentObject(textTheme)
}
