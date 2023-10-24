//
//  VerticalSliderView.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 2023/09/22.
//
//  Original code from https://swdevnotes.com/swift/2021/how-to-customise-the-slider-in-swiftui/#documentTop
//

import SwiftUI

struct VerticalSliderView: View {
    @Binding var value: CGFloat
    
    @State var valueRange: ClosedRange<CGFloat>
    @State var lastCoordinateValue: CGFloat = 0.0
    
    @State var sliderLineColor: Color = .gray
    @State var sliderButtonColor: Color = .black
    
    var body: some View {
        GeometryReader { geometryReader in
            let size = geometryReader.size
            
            let thumbSize = size.width * 0.8
            let radius = size.width * 0.5
            let minY = size.height * 0.015
            let maxY = size.height * 0.98 - thumbSize
            
            let scaleFactor = (maxY - minY) / (valueRange.upperBound - valueRange.lowerBound)
            let sliderValue = (self.value - valueRange.lowerBound) * scaleFactor + minY
            
            ZStack {
                RoundedRectangle(cornerRadius: radius)
                    .foregroundStyle(sliderLineColor)
                    .frame(width: radius * 0.5)
                    .padding(.vertical, radius * 0.5)
                VStack {
                    Circle()
                        .stroke()
                        .foregroundStyle(Color.white)
                        .frame(width: thumbSize, height: thumbSize)
                        .offset(y: sliderValue)
                        .background(
                            Circle()
                                .foregroundStyle(Color.black)
                                .offset(y: sliderValue)
                        )
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { v in
                                    if (abs(v.translation.height) < 0.1) {
                                        self.lastCoordinateValue = sliderValue
                                    }
                                    
                                    if v.translation.height > 0 {
                                        let nextCoordinateValue = min(maxY, self.lastCoordinateValue + v.translation.height)
                                        self.value = ((nextCoordinateValue - minY) / scaleFactor)  + valueRange.lowerBound
                                    } else {
                                        let nextCoordinateValue = max(minY, self.lastCoordinateValue + v.translation.height)
                                        self.value = ((nextCoordinateValue - minY) / scaleFactor) + valueRange.lowerBound
                                    }
                                }
                            
                        )
                    Spacer()
                }
                
            }
        }
    }
}
