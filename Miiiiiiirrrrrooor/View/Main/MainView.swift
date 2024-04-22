//
//  MirrorView.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 2023/09/19.
//

import SwiftUI
import MessageUI

struct MainView: View {
    internal let mail = "paser2@gmail.com"
    
    //MARK: - Variables
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject internal var uiTheme: UITheme
    @EnvironmentObject internal var textTheme: TextTheme
    
    @StateObject internal var model = ViewModel()
    @StateObject internal var uiModel = UIModel()
    
    @State internal var result: Result<MFMailComposeResult, Error>? = nil
    
    @State internal var toastTimer: Timer?
    
    @State internal var isPhotoConfirming = false
        
    //MARK: - Main View
    var body: some View {
        GeometryReader { geometryReader in
            ZStack {
                // Camera
                ZStack() {
                    FrameView(image: model.frame,
                              zoomRate: model.zoomRate,
                              position: model.offset)
                        .ignoresSafeArea()
                    ErrorView(error: model.error)
                }
                
                // Common action area
                Rectangle()
                    .foregroundStyle(Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if uiModel.isUIHidden { uiModel.isUIHidden = false }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let x = value.translation.width - uiModel.lastTranslation.width
                                let y = value.translation.height - uiModel.lastTranslation.height
                                                                
                                model.adjustOffset(CGPoint(x: x, y: y))
                                
                                uiModel.lastTranslation = value.translation
                            }
                            .onEnded { _ in
                                uiModel.lastTranslation = .zero
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / uiModel.previousZoom
                                uiModel.previousZoom = value
                                let newZoom = model.zoomRate * delta
                                model.setZoomRate(newZoom)
                            }
                            .onEnded { value in
                                uiModel.previousZoom = 1.0
                            }
                    )
                // Main UI
                VStack() {
                    if !uiModel.isUIHidden {
                        HStack() {
                            hideUIButton
                                .padding(.horizontal, uiTheme.paddingUnit)
                            infoButton
                                .padding(.horizontal, uiTheme.paddingUnit)
                        }
                        if !uiModel.isInfoHidden {
                            infoView
                        }
                        
                        Spacer() //blank space
                        
                        ZStack() {
                            if !uiModel.isZoomHidden {
                                zoomChangeView
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                            }
                            toastTextView
                                .frame(maxHeight: .infinity, alignment: .bottom)
                                .padding(.bottom, uiTheme.paddingUnit)
                            
                            if !uiModel.isFilterListHidden {
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
            .sheet(isPresented: $uiModel.isShowingMailView) {
                MailView(isShowing: $uiModel.isShowingMailView,
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
                
                model.viewSize = geometryReader.size
                uiModel.viewSize = geometryReader.size
            }
            .fullScreenCover(isPresented: $isPhotoConfirming) {
                PhotoConfirmView(photoImage: model.frame)
            }
        }
    }
}
    

//MARK: - Preview Setting
#Preview {
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    let textTheme = ThemePreview.WhitePreview.textTheme
    
    return MainView()
        .environmentObject(uiTheme)
        .environmentObject(textTheme)
}
