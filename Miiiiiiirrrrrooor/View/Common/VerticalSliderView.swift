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
    
    @State private(set) var valueRange: ClosedRange<CGFloat>
    @State private(set) var lastCoordinateValue: CGFloat = 0.0
    
    @State var sliderLineColor: Color = .gray
    @State var sliderButtonColor: Color = .black
    
    private var isDown: Bool { direction == .toBottom }
    
    var body: some View {
        GeometryReader { geometryReader in
            let size = geometryReader.size
            
            let thumbSize = size.width * 0.8
            let radius = size.width * 0.5
            let minY = size.height * 0.015
            let maxY = size.height * 0.98 - thumbSize
            
            let topSpaceHeight: CGFloat = isDown ? 0 : .infinity
            let bottomSpaceHeight: CGFloat = isDown ? .infinity : 0
            
            let scaleFactor = getScaleFactor(minY: minY, maxY: maxY)
            let sliderValue = getSliderValue(value: self.value, scaleFactor: scaleFactor, isDown: isDown, minY: minY, maxY: maxY)
            
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
                                    updateZoomFactor(sliderValue: sliderValue, dragValue: v, minY: minY, maxY: maxY, scaleFactor: scaleFactor)
                                }
                        )
                    
                    Spacer()
                        .frame(maxHeight: bottomSpaceHeight)
                }
            }
        }
    }
    
}

//#MARK: - Parameter Functions
extension VerticalSliderView {
    public func getSliderValue(value: CGFloat, scaleFactor:CGFloat, isDown: Bool, minY: CGFloat, maxY: CGFloat) -> CGFloat {
        isDown ? (value - valueRange.lowerBound) * scaleFactor + minY : -((value - valueRange.lowerBound) * scaleFactor + minY)
    }
    
    public func setValueRange(_ value: ClosedRange<CGFloat>) {
        self.valueRange = value
    }
    
    public func setLastCoordinator(_ value: CGFloat) {
        self.lastCoordinateValue = value
    }
    
    public func getScaleFactor(minY: CGFloat, maxY: CGFloat) -> CGFloat {
        (maxY - minY) / (valueRange.upperBound - valueRange.lowerBound)
    }
    
    public func updateValue(_ value: CGFloat) {
        self.value = value
    }
}

//MARK: - Update function
extension VerticalSliderView {
    internal func updateZoomFactor(sliderValue: CGFloat, dragValue: DragGesture.Value, minY: CGFloat, maxY: CGFloat, scaleFactor: CGFloat) {
        if (abs(dragValue.translation.height) < 0.1) {
            setLastCoordinator(sliderValue)
        }
        
        var nextCoordinateValue: CGFloat = 0
        
        if dragValue.translation.height > 0 {
            // drag to down
            nextCoordinateValue = isDown ? min(maxY, self.lastCoordinateValue + dragValue.translation.height) : max(minY, -(self.lastCoordinateValue + dragValue.translation.height))
        } else {
            // drag to up
            nextCoordinateValue = isDown ? max(minY, self.lastCoordinateValue + dragValue.translation.height) : min(maxY, -(self.lastCoordinateValue + dragValue.translation.height))
        }
        
        updateValue((nextCoordinateValue - minY) / scaleFactor + self.valueRange.lowerBound)
    }
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
