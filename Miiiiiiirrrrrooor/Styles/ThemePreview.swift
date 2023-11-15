//
//  ThemePreview.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 11/15/23.
//

import Foundation

class ThemePreview {    
    private let settings: PreviewSetting
    
    init(_ settings: PreviewSetting) {
        self.settings = settings
    }
    
    var uiTheme: UITheme { settings.uiTheme }
    var textTheme: TextTheme { settings.textTheme }
}

class PreviewSetting {
    let uiTheme: UITheme
    let textTheme: TextTheme
    
    init(uiTheme: UITheme, textTheme: TextTheme) {
        self.uiTheme = uiTheme
        self.textTheme = textTheme
    }
}

//MARK: - Pre setting values
extension ThemePreview {
    private static var unitSize: CGFloat { 32 }
    private static var defaultFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        
        return formatter
    }
    
    static let DarkPreview: ThemePreview = ThemePreview(PreviewSetting(
        uiTheme: UITheme(sizeUnit: unitSize,
                         paddingUnit: unitSize * 0.5,
                         cornerRadius: 10,
                         mainColor: .white,
                         imageButtonOpacity: 0.5),
        
        textTheme: TextTheme(textScaleRate: 1,
                             textColor: .white,
                             numberFormatter: defaultFormatter,
                             textButtonOpacity: 0.1,
                             textAreaOpacity: 0.25)
    ))
    
    static let WhitePreview: ThemePreview = ThemePreview(PreviewSetting(
        uiTheme: UITheme(sizeUnit: unitSize,
                         paddingUnit: unitSize * 0.5,
                         cornerRadius: 10,
                         mainColor: .black,
                         imageButtonOpacity: 0.5),
        
        textTheme: TextTheme(textScaleRate: 1,
                             textColor: .black,
                             numberFormatter: defaultFormatter,
                             textButtonOpacity: 0.1,
                             textAreaOpacity: 0.1)
    ))
}
