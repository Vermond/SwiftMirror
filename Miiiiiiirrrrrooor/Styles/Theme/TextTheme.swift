//
//  TextTheme.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 10/30/23.
//

import SwiftUI

class TextTheme: ObservableObject {
    @Published var textScaleRate: CGFloat
    @Published var textColor: Color
    @Published var numberFormatter: NumberFormatter
    
    @Published var textButtonOpacity: CGFloat
    @Published var textAreaOpacity: CGFloat
    
    init(textScaleRate: CGFloat = 1.5,
         textColor: Color = .white,
         numberFormatter: NumberFormatter = NumberFormatter(),
         textButtonOpacity: CGFloat = 1,
         textAreaOpacity: CGFloat = 1)
    {
        self.textScaleRate = textScaleRate
        self.textColor = textColor
        self.numberFormatter = numberFormatter
        self.textButtonOpacity = textButtonOpacity
        self.textAreaOpacity = textAreaOpacity
    }
    
    func numberToString(_ value: CGFloat) -> String {
        return numberFormatter.string(from: NSNumber(value: value)) ?? ""
    }
}
