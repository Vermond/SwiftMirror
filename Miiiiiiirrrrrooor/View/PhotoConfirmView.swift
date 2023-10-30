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
    
    @Binding var photoImage: UIImage?
    
    @State private var isFlipped = false
    
    private let maxButtonHeight: CGFloat = 70
    private let buttonOpacity: CGFloat = 0.35
    private let buttonAreaOpacity: CGFloat = 0.1
    private let buttonAreaPadding: CGFloat = 20
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    if let image = photoImage {
                        photoImage = UIImage(cgImage: image.cgImage!, scale: 1, orientation: isFlipped ? .right : .leftMirrored)
                        
                        isFlipped = !isFlipped
                    }                    
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
                        PhotoController.shared.writeToPhotoAlbum(image: photoImage) { error in
                            if let error {
                                if PhotoController.shared.isAlbumAuthorized {
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
        .background(
            Image(uiImage: photoImage!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
        .onDisappear {
            photoImage = nil
        }
    }
}

#Preview {
    let uiTheme = UITheme.DarkPreviewSetting
    let textTheme = TextTheme.DarkPreviewSetting
    
    @State var previewImage: UIImage? = UIImage()
    
    return PhotoConfirmView(photoImage: $previewImage)
        .environmentObject(uiTheme)
        .environmentObject(textTheme)
}
