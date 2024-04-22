//
//  FrameView.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/16/24.
//
//  from https://www.kodeco.com/26244793-building-a-camera-app-with-swiftui-and-combine

import Foundation
import SwiftUI

struct FrameView: View {
    var image: CGImage?
    private let label = Text("Mirror")
    
    var zoomRate: CGFloat
    var position: CGPoint
    
    init(image: CGImage?, zoomRate: CGFloat, position: CGPoint) {
        self.image = image
        self.zoomRate = zoomRate
        self.position = position
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                if let image {
                    Image(image, scale: 1, orientation: .upMirrored, label: label)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                    
                } else {
                    Color.white
                }
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height,
                   alignment: .center)
            .scaleEffect(zoomRate)
            .offset(x: position.x, y: position.y)
        }
    }
}
