//
//  MainView+Function.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 3/21/24.
//

import Foundation
import SwiftUI

//MARK: - Functions
extension MainView {
    internal func showToast(_ text: String, duration: TimeInterval) {
        uiModel.toastText = text
        uiModel.toastOpacity = 1
        
        if let toastTimer {
            toastTimer.invalidate()
            self.toastTimer = nil
        }
        
        toastTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { timer in
            uiModel.toastOpacity = 0
            uiModel.toastText = ""
            self.toastTimer = nil
        }
    }
    
    internal func openUrl(to path: String) {
        if let url = URL(string: path), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
