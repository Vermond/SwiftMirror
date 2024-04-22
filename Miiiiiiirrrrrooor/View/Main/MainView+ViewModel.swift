//
//  MainView.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 2023/09/19.
//

import SwiftUI
import AVFoundation

extension MainView {
    class ViewModel: ObservableObject {
        @Published var viewSize: CGSize = .zero
        
        @Published private(set) var zoomRange: ClosedRange<CGFloat> = 1...3
        @Published private(set) var zoomRate: CGFloat = 1        
        @Published private(set) var offset: CGPoint = .zero
        
        @Published var frame: CGImage?
        @Published var filter: Filters = .None
        @Published var error: Error?
        
        private let cameraManager = CameraManager.shared
        private let frameManager = FrameManager.shared
        private let context = CIContext()
        
        private var maxOffset: CGPoint = .zero
        private var prevOffset: CGPoint = .zero
        
        var zoomRateBinding: Binding<CGFloat> {
            Binding(
                get: { self.zoomRate },
                set: { newValue in self.setZoomRate(newValue) }
            )
        }
        
        init() {
            setupSubscription()
        }
        
        func setupSubscription() {
            frameManager.$current
                .receive(on: RunLoop.main)
                .compactMap { $0 }
                .compactMap { [unowned self] buffer in
                    guard let image = CGImage.create(from: buffer) else { return nil }
                    
                    var ciImage = CIImage(cgImage: image)
                    
                    if let filter = filter.filter {
                        filter.setValue(ciImage, forKey: kCIInputImageKey)
                        
                        guard let filterImage = filter.outputImage else { return nil }
                        ciImage = filterImage
                    }
                    
                    return context.createCGImage(ciImage, from: ciImage.extent)
                }
                .assign(to: &$frame)
            
            cameraManager.$error
                .receive(on: RunLoop.main)
                .map { $0 }
                .assign(to: &$error)
        }
        
        public func setZoomRate(_ rate: CGFloat) {
            self.zoomRate = min(max(rate, zoomRange.lowerBound), zoomRange.upperBound)
            setMaxOffset(size: self.viewSize, zoomRate: self.zoomRate)
            adjustOffset(self.offset)
        }
        
        public func adjustOffset(_ offset: CGPoint) {
            let tx = prevOffset.x + offset.x
            let ty = prevOffset.y + offset.y
            
            let x = min(max(-self.maxOffset.x, tx), self.maxOffset.x)
            let y = min(max(-self.maxOffset.y, ty), self.maxOffset.y)
            
            self.offset = CGPoint(x: x, y: y)
            prevOffset = self.offset
        }
        
        private func setMaxOffset(size: CGSize, zoomRate: CGFloat) {
            if zoomRate < 1.01 {
                self.maxOffset = .zero
            } else {
                self.maxOffset = CGPoint(x: (size.width * zoomRate - size.width) / 2,
                                         y: (size.height * zoomRate - size.height) / 2)
            }
        }
    }
    
    class UIModel: ObservableObject {
        @Published var isUIHidden = false
        @Published var isInfoHidden = true
        @Published var isShowingMailView = false
        
        @Published var toastText: String = ""
        @Published var toastOpacity: CGFloat = 0
        
        @Published var isZoomHidden = true
        @Published var isFilterListHidden = true
        
        @Published var viewSize: CGSize = .zero
        @Published var lastPosition: CGPoint? = nil
        
        @Published var lastTranslation: CGSize = .zero
        @Published var previousZoom: CGFloat = 1.0
        
        
    }
}
