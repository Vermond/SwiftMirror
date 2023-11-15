//
//  MirrorViewModel.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 2023/09/19.
//

import SwiftUI
import Foundation
import AVFoundation

class MirrorViewModel: ObservableObject {
    @Published var currentPreviewQuality: AVCaptureSession.Preset = .high
    
    @Published var zoomRange: ClosedRange<CGFloat> = 1...3
    @Published var zoomRate: CGFloat = 1
}
