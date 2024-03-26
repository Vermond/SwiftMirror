//
//  MirrorViewModel.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 2023/09/19.
//

import SwiftUI
import Foundation
import AVFoundation

typealias Offset = (x: CGFloat, y: CGFloat)

extension MirrorView {
    
    class ViewModel: ObservableObject {        
        @Published private(set) var zoomRange: ClosedRange<CGFloat> = 1...3
        @Published private(set) var zoomRate: CGFloat = 1
        
        @Published private(set) var offset: Offset = (0, 0)
        
        var zoomRateBinding: Binding<CGFloat> {
            Binding(
                get: { self.zoomRate },
                set: { newValue in self.zoomRate = newValue }
            )
        }
        
        public func setZoomRate(_ rate: CGFloat) {
            self.zoomRate = min(max(rate, zoomRange.lowerBound), zoomRange.upperBound)
        }
        
        public func adjustOffset(_ offset: Offset) {
            self.offset = (offset.x, offset.y)
        }
    }
}
