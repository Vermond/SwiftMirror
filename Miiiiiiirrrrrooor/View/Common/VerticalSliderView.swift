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
    enum Direction { case toTop; case toBottom }
    
    @Binding var value: CGFloat
    
    @State var direction = Direction.toTop
    
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
            let sliderValue = isDown ? (self.value - valueRange.lowerBound) * scaleFactor + minY : -((self.value - valueRange.lowerBound) * scaleFactor + minY)
            
            let topSpaceHeight: CGFloat = isDown ? 0 : .infinity
            let bottomSpaceHeight: CGFloat = isDown ? .infinity : 0
            
            ZStack {
                RoundedRectangle(cornerRadius: radius)
                    .foregroundStyle(sliderLineColor)
                    .frame(width: radius * 0.5)
                    .padding(.vertical, radius * 0.5)
                
                VStack {
                    Spacer()
                        .frame(maxHeight: topSpaceHeight)
                    
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
                                    
                                    var nextCoordinateValue: CGFloat = 0
                                    
                                    if v.translation.height > 0 {
                                        // drag to down
                                        nextCoordinateValue = isDown ? min(maxY, self.lastCoordinateValue + v.translation.height) : max(minY, -(self.lastCoordinateValue + v.translation.height))
                                    } else {
                                        // drag to up
                                        nextCoordinateValue = isDown ? max(minY, self.lastCoordinateValue + v.translation.height) : min(maxY, -(self.lastCoordinateValue + v.translation.height))
                                    }
                                    
                                    self.value = (nextCoordinateValue - minY) / scaleFactor + valueRange.lowerBound
                                }
                        )
                    
                    Spacer()
                        .frame(maxHeight: bottomSpaceHeight)
                }
            }
        }
    }
    
    private var isDown: Bool { direction == .toBottom }
}


#Preview {
    @State var valueRange: ClosedRange<CGFloat> = 10...30
    @State var value: CGFloat = 25
    
    var view: any View {
        VerticalSliderView(value: $value, valueRange: valueRange)
            .frame(width: 36, height: 180)
    }
    
    return view
}
