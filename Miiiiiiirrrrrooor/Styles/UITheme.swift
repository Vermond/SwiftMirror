//
//  UITheme.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 10/6/23.
//

import SwiftUI

class UITheme: ObservableObject  {
    @Published var sizeUnit: CGFloat
    @Published var paddingUnit: CGFloat
    @Published var cornerRadius: CGFloat
    
    @Published var mainColor: Color
    @Published var imageButtonOpacity: CGFloat
    
    init(sizeUnit: CGFloat = 0,
         paddingUnit: CGFloat = 0,
         cornerRadius: CGFloat = 0,
         mainColor: Color = .white,
         imageButtonOpacity: CGFloat = 1)
    {
        self.sizeUnit = sizeUnit
        self.paddingUnit = paddingUnit
        self.cornerRadius = cornerRadius
        self.mainColor = mainColor
        self.imageButtonOpacity = imageButtonOpacity
    }
    
    var mainImageButtonBackground: Color { mainColor.opacity(imageButtonOpacity) }
}
