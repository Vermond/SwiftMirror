//
//  AVCaptureSessionPreset+Extension.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 11/15/23.
//

import AVFoundation

extension AVCaptureSession.Preset {
    mutating func toggle() {
        if self == .high {
            self = .low
        } else {
            self = .high
        }
    }
}
