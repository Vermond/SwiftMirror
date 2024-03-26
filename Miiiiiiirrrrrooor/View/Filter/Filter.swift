//
//  Filter.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 3/25/24.
//

import Foundation
import AVFoundation
import CoreImage

enum Filters: String, CaseIterable {
    case None
    case ColorControls
    case ExposureAdjust
    case PhotoEffectChrome
    case PhotoEffectFade
    case PhotoEffectTonal
    case SharpenLuminance
    case UnsharpMask
    case Bloom
    
    var name: String {
        return switch self {
        case .None:
            "None"
        case .ColorControls:
            "Color Controls"
        case .ExposureAdjust:
            "Exposure Adjust"
        case .PhotoEffectChrome:
            "Photo Effect Chrome"
        case .PhotoEffectFade:
            "Photo Effect Fade"
        case .PhotoEffectTonal:
            "Photo Effect Tonal"
        case .SharpenLuminance:
            "Sharpen Luminance"
        case .UnsharpMask:
            "Unsharp Mask"
        case .Bloom:
            "Bloom"
        }
    }
    
    var filter: CIFilter? {
        switch self {
        case .None:
            return nil
        case .ColorControls:
            let filter = CIFilter(name: "CIColorControls")
            filter?.setValue(1.25, forKey: kCIInputSaturationKey)
            filter?.setValue(0.05, forKey: kCIInputBrightnessKey)
            filter?.setValue(1.05, forKey: kCIInputContrastKey)
            return filter
        case .ExposureAdjust:
            let filter = CIFilter(name: "CIExposureAdjust")
            filter?.setValue(0.25, forKey: kCIInputEVKey)
            return filter
        case .PhotoEffectChrome:
            let filter = CIFilter(name: "CIPhotoEffectChrome")
            return filter
        case .PhotoEffectFade:
            let filter = CIFilter(name: "CIPhotoEffectFade")
            return filter
        case .PhotoEffectTonal:
            let filter = CIFilter(name: "CIPhotoEffectTonal")
            return filter
        case .SharpenLuminance:
            let filter = CIFilter(name: "CISharpenLuminance")
            filter?.setValue(0.4, forKey: kCIInputSharpnessKey)
            return filter
        case .UnsharpMask:
            let filter = CIFilter(name: "CIUnsharpMask")
            filter?.setValue(2.5, forKey: kCIInputRadiusKey)
            filter?.setValue(0.5, forKey: kCIInputIntensityKey)
            return filter
        case .Bloom:
            let filter = CIFilter(name: "CIBloom")
            filter?.setValue(10, forKey: kCIInputRadiusKey)
            filter?.setValue(0.5, forKey: kCIInputIntensityKey)
            return filter
        }
    }
}
