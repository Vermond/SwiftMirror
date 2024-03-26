//
//  MirrorView.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 2023/09/19.
//

import SwiftUI
import MessageUI

struct MirrorView: View {
    internal let mail = "paser2@gmail.com"
    
    //MARK: - Variables
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject internal var uiTheme: UITheme
    @EnvironmentObject internal var textTheme: TextTheme
    
    @ObservedObject internal var model = ViewModel()
    
    @State internal var isUIHidden = false
    @State internal var isInfoHidden = true
    @State internal var result: Result<MFMailComposeResult, Error>? = nil
    @State internal var isShowingMailView = false
    
    @State internal var toastText: String = ""
    @State internal var toastOpacity: CGFloat = 0
    @State internal var toastTimer: Timer?
    
    @State internal var isZoomHidden = true
    @State internal var isFilterListHidden = true
    
    @State internal var isWaitingForCapture = false
    
    @State internal var currentFilter: Filters = .None
    
    @State internal var photoImage: UIImage?
    @State internal var isPhotoConfirming = false
    
    @State private var viewSize: CGSize = .zero
    @State private var lastPosition: CGPoint? = nil
    
    @State private var lastTranslation: CGSize = .zero
    @State private var previousZoom: CGFloat = 1.0
    
    //MARK: - Main View
    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
                // Common action area
                Rectangle()
                    .foregroundStyle(Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isUIHidden { isUIHidden = false }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let x = value.translation.width - lastTranslation.width
                                let y = value.translation.height - lastTranslation.height
                                                                
                                model.adjustOffset((x, y))
                                
                                self.lastTranslation = value.translation
                            }
                            .onEnded { _ in
                                self.lastTranslation = .zero
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / previousZoom
                                self.previousZoom = value
                                let newZoom = model.zoomRate * delta
                                model.setZoomRate(newZoom)
                            }
                            .onEnded { value in
                                self.previousZoom = 1.0
                            }
                    )
                
                // Main UI
                VStack() {
                    if !isUIHidden {
                        HStack() {
                            hideUIButton
                                .padding(.horizontal, uiTheme.paddingUnit)
                            infoButton
                                .padding(.horizontal, uiTheme.paddingUnit)
                        }
                        if !isInfoHidden {
                            infoView
                        }
                        
                        Spacer() //blank space
                        
                        ZStack() {
                            if !isZoomHidden {
                                zoomChangeView
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                            }
                            toastTextView
                                .frame(maxHeight: .infinity, alignment: .bottom)
                                .padding(.bottom, uiTheme.paddingUnit)
                            
                            if !isFilterListHidden {
                                filterSelectList
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                            }
                        }
                        .frame(height: uiTheme.sizeUnit * 7.5)
                        .padding(uiTheme.paddingUnit)
                        
                        HStack() {
                            currentZoomButton
                                .frame(maxWidth: 100)
                            Spacer()
                            takePictureButton
                            Spacer()
                            filterMainButton
                                .frame(maxWidth: 100)
                        }
                        .padding(.horizontal, uiTheme.paddingUnit)
                    }
                }
            }
            .background(
                VStack() {
                    CameraPreviewRepresentable(model: self.model,
                                               viewSize: $viewSize,
                                               isWaitingForCapture: $isWaitingForCapture,
                                               photoImage: $photoImage,
                                               currentFilter: $currentFilter)
                }
                    .ignoresSafeArea()
            )
            .sheet(isPresented: $isShowingMailView) {
                MailView(isShowing: self.$isShowingMailView,
                         result: self.$result,
                         targetMail: mail)
            }
            .onAppear {
                //init theme
                let size = geometryReader.size.width / 10
                let isDark = colorScheme == .dark
                
                uiTheme.sizeUnit = size
                uiTheme.paddingUnit = size * 0.5
                uiTheme.cornerRadius = 10
                uiTheme.mainColor = isDark ? .white : .black
                uiTheme.imageButtonOpacity = 0.5
                
                textTheme.textScaleRate = 1
                textTheme.textColor = isDark ? .white : .black
                textTheme.numberFormatter.numberStyle = .decimal
                textTheme.numberFormatter.minimumFractionDigits = 1
                textTheme.numberFormatter.maximumFractionDigits = 1
                textTheme.textButtonOpacity = 0.1
                textTheme.textAreaOpacity = isDark ? 0.25 : 0.1
                
                self.viewSize = geometryReader.size
            }
            .onChange(of: isWaitingForCapture) { isWaiting in
                isPhotoConfirming = !isWaiting && photoImage != nil
            }
            .fullScreenCover(isPresented: $isPhotoConfirming) {
                PhotoConfirmView(photoImage: $photoImage)
            }
        }
    }
}
    

//MARK: - Preview Setting
#Preview {
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    let textTheme = ThemePreview.WhitePreview.textTheme
    
    return MirrorView()
        .environmentObject(uiTheme)
        .environmentObject(textTheme)
}
