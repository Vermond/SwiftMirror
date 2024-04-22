//
//  PhotoConfirmView.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 10/5/23.
//

import SwiftUI

struct PhotoConfirmView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var uiTheme: UITheme
    
    @State var photoImage: CGImage?
    
    @State private var isFlipped = false
    
    private let maxButtonHeight: CGFloat = 70
    private let buttonOpacity: CGFloat = 0.35
    private let buttonAreaOpacity: CGFloat = 0.1
    private let buttonAreaPadding: CGFloat = 20
    
    var body: some View {
        ZStack {
            if let photoImage {
                Image(photoImage, scale: 1, label: Text(""))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea()
                    .scaleEffect(x: isFlipped ? 1 : -1)
            } else {
                Color.white
            }
            
            VStack {
                HStack {
                    Button(action: {
                        isFlipped.toggle()
                    }, label: {
                        Image(systemName: "arrow.left.and.right.circle.fill")
                            .scaleEffect(3)
                            .foregroundStyle(uiTheme.mainColor)
                    })
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .foregroundStyle(uiTheme.mainColor)
                            .frame(maxWidth: .infinity, maxHeight: maxButtonHeight)
                    })
                    .background(
                        RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                            .stroke()
                            .foregroundStyle(uiTheme.mainColor)
                            .background(
                                RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                                    .foregroundStyle(uiTheme.mainColor.opacity(buttonOpacity))
                            )
                    )
                    
                    Spacer()
                        .frame(maxWidth: buttonAreaPadding)
                    
                    Button(action: {
                        if let photoImage {
                            PhotoManager.shared.writeToPhotoAlbum(image: photoImage, isFlipped: self.isFlipped) { error in
                                if let error {
                                    if PhotoManager.shared.isAlbumAuthorized {
                                        print("unknown error \(error.localizedDescription)")
                                    } else {
                                        print("need auth")
                                    }
                                } else {
                                    dismiss()
                                }
                            }
                        }
                    }, label: {
                        Text("Save")
                            .foregroundStyle(uiTheme.mainColor)
                            .frame(maxWidth: .infinity, maxHeight: maxButtonHeight)
                    })
                    .background(
                        RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                            .stroke()
                            .foregroundStyle(uiTheme.mainColor)
                            .background(
                                RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                                    .foregroundStyle(uiTheme.mainColor.opacity(buttonOpacity))
                            )
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(buttonAreaPadding)
                .background(
                    RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                        .foregroundStyle(uiTheme.mainColor.opacity(buttonAreaOpacity))
                )
            }
            .padding(.horizontal, buttonAreaPadding)
            .onDisappear {
                photoImage = nil
            }
        }
    }
}

#Preview {
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    let textTheme = ThemePreview.WhitePreview.textTheme
    
    @State var previewImage: CGImage? = nil
    return PhotoConfirmView(photoImage: previewImage)
        .environmentObject(uiTheme)
        .environmentObject(textTheme)
}
