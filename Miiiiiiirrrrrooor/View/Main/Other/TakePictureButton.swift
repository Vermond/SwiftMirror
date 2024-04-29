//
//  TakePictureButton.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI

struct TakePictureButton: View {
    @EnvironmentObject internal var uiTheme: UITheme
    
    @Binding var isPhotoConfirming: Bool
    
    var body: some View {
        Button(action: {
            isPhotoConfirming = true
        }) {
            Circle()
                .stroke()
                .foregroundStyle(uiTheme.mainColor)
                .frame(width: uiTheme.sizeUnit * 1.15)
                .background(
                    CircleOutline()
                        .background(
                            Circle().foregroundStyle(uiTheme.mainImageButtonBackground)
                        )
                )
        }
    }
}

#Preview {
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    
    @State var isPhotoConfirming = false
    
    return TakePictureButton(isPhotoConfirming: $isPhotoConfirming)
        .environmentObject(uiTheme)
}
