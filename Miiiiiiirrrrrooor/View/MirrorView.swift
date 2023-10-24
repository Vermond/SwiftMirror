//
//  MirrorView.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 2023/09/19.
//

import SwiftUI
import MessageUI

struct MirrorView: View {
    //MARK: - Variables
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var uiTheme: UITheme
    @EnvironmentObject var textTheme: TextTheme
    
    @ObservedObject private var viewModel = MirrorViewModel()
    
    @State private var isInfoHidden = true
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    
    @State private var toastText: String = ""
    @State private var toastOpacity: CGFloat = 0
    @State private var toastTimer: Timer?
    
    @State private var isZoomHidden = true
    
    @State private var isWaitingForChangeQuality = false
    @State private var isWaitingForCapture = false
    
    @State private var photoImage: UIImage?
    @State var isPhotoConfirming = false
    
    private let mail = "paser2@gmail.com"
    
    //MARK: - Main View
    var body: some View {
        GeometryReader { geometryReader in
            VStack() {
                infoButton
                    .padding(.horizontal, uiTheme.paddingUnit)
                if !isInfoHidden {
                    infoView
                }
                
                Spacer() //blank space
                
                ZStack() {
                    if !isZoomHidden {
                        zoomChangeView
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    toastTextView
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, uiTheme.paddingUnit)
                }
                .frame(height: uiTheme.sizeUnit * 5)
                .padding(uiTheme.paddingUnit)
                
                HStack() {
                    currentZoomButton
                    Spacer()
                    takePictureButton
                    Spacer()
                    qualityButton
                }
                .padding(.horizontal, uiTheme.paddingUnit)
            }
            .background(
                VStack() {
                    CameraPreviewRepresentable(viewModel: viewModel,
                                               isWaitingForChangeQuality: $isWaitingForChangeQuality,
                                               isWaitingForCapture: $isWaitingForCapture,
                                               photoImage: $photoImage)
                }
                .ignoresSafeArea()
            )
            .sheet(isPresented: $isShowingMailView) {
                MailView(isShowing: self.$isShowingMailView,
                         result: self.$result,
                         targetMail: mail)
            }
            .onAppear {
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
            }
            .onChange(of: isWaitingForCapture) { isWaiting in
                isPhotoConfirming = !isWaiting && photoImage != nil
            }
            .fullScreenCover(isPresented: $isPhotoConfirming) {
                PhotoConfirmView(photoImage: $photoImage)
            }
        }
    }
    
    //MARK: - Main Button View Item
    private var infoButton: some View {
        Button(action: {
            isInfoHidden.toggle()
        }) {
            Image(systemName: "info.circle.fill")
                .scaleEffect(2)
                .foregroundStyle(uiTheme.mainImageButtonBackground)
                .frame(width: uiTheme.sizeUnit, height: uiTheme.sizeUnit)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var currentZoomButton: some View {
        Button(action: {
            isZoomHidden.toggle()
        }, label: {
            Text("x \(textTheme.numberToString(viewModel.zoomRate))")
                .scaleEffect(textTheme.textScaleRate)
                .foregroundStyle(textTheme.textColor)
                .frame(width: uiTheme.sizeUnit * 1.75, height: uiTheme.sizeUnit)
        })
        .background(
            RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                .stroke()
                .foregroundStyle(uiTheme.mainColor)
                .background(
                    RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                        .foregroundStyle(uiTheme.mainImageButtonBackground)
                )
        )
        
    }
    
    private var takePictureButton: some View {
        Button(action: {
            isWaitingForCapture = true
        }) {
            Circle()
                .stroke()
                .foregroundStyle(uiTheme.mainColor)
                .frame(width: uiTheme.sizeUnit * 1.15)
                .background(
                    Circle()
                        .stroke()
                        .frame(width: uiTheme.sizeUnit)
                        .foregroundStyle(uiTheme.mainColor)
                        .background(
                            Circle().foregroundStyle(uiTheme.mainImageButtonBackground)
                        )
                )
        }
    }
    
    private var qualityButton: some View {
        Button(action: {
            viewModel.toggleQuality()
            isWaitingForChangeQuality = true
            
            let newQuality = viewModel.currentPreviewQuality == .high ? "high" : "low"
            
            showToast("Change quality to \(newQuality)", duration: 1)
        }, label: {
            Text(viewModel.currentPreviewQuality == .high ? "H" : "L")
                .scaleEffect(textTheme.textScaleRate)
                .foregroundStyle(textTheme.textColor)
                .frame(width: uiTheme.sizeUnit * 1.75, height: uiTheme.sizeUnit)
        })
        .background(
            RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                .stroke()
                .foregroundStyle(uiTheme.mainColor)
                .frame(width: uiTheme.sizeUnit)
                .background(
                    RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                        .foregroundStyle(uiTheme.mainImageButtonBackground)
                )
        )
    }
    
    //MARK: - Main Sub View Item
    private var infoView: some View {
        GeometryReader { gr in
            let maxWidth = gr.size.width * 0.4
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            let unit = uiTheme.paddingUnit
            
            VStack {
                Text("Ver. \(appVersion ?? "-")")
                    .frame(maxWidth: maxWidth, alignment: .trailing)
                    .foregroundStyle(textTheme.textColor)
                    .multilineTextAlignment(.trailing)
                    .padding(.trailing, unit)
                    .padding(.top, unit)
                
                Text("⌾ Develop by\nJinsu Gu")
                    .frame(maxWidth: maxWidth, alignment: .trailing)
                    .foregroundStyle(textTheme.textColor)
                    .multilineTextAlignment(.trailing)
                    .padding(.trailing, unit)
                    .padding(.top, unit)
                
                    if MFMailComposeViewController.canSendMail() {
                        Button(action: {
                            self.isShowingMailView.toggle()
                        }, label: {
                            Text("Mail to me")
                                .frame(maxWidth: maxWidth, alignment: .trailing)
                                .padding(.trailing, unit)
                        })
                    } else {
                        Text("Mail: \(mail)")
                            .frame(maxWidth: maxWidth, alignment: .trailing)
                            .padding(.trailing, unit)
                    }
            
                Text("⌾ Icon by Freepik\nfrom Flaticon")
                    .frame(maxWidth: maxWidth, alignment: .trailing)
                    .foregroundStyle(textTheme.textColor)
                    .multilineTextAlignment(.trailing)
                    .padding(.trailing, unit)
                    .padding(.top, unit)
                
                Button(action: {
                    let web = "https://www.flaticon.com/"
                    openUrl(to: web)
                }, label: {
                    Text("Go to Flaticon")
                        .frame(maxWidth: maxWidth, alignment: .trailing)
                        .padding(.trailing, unit)
                        .padding(.bottom, unit)
                })
            }
            .background(
                RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                    .foregroundStyle(uiTheme.mainImageButtonBackground)
            )
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, uiTheme.paddingUnit)
            
        }
    }
    
    private var zoomChangeView: some View {
        HStack {
            VerticalSliderView(value: $viewModel.zoomRate, valueRange: viewModel.zoomRange)
                .frame(width: uiTheme.sizeUnit, height: uiTheme.sizeUnit * 5)
                
            VStack {
                Text("x\(textTheme.numberToString(viewModel.zoomRange.lowerBound))")
                    .foregroundStyle(textTheme.textColor)
                    .frame(width: uiTheme.sizeUnit, height: uiTheme.sizeUnit)
                Spacer()
                Text("x\(textTheme.numberToString(viewModel.zoomRange.middleBound))")
                    .foregroundStyle(textTheme.textColor)
                    .frame(width: uiTheme.sizeUnit, height: uiTheme.sizeUnit)
                Spacer()
                Text("x\(textTheme.numberToString(viewModel.zoomRange.upperBound))")
                    .foregroundStyle(textTheme.textColor)
                    .frame(width: uiTheme.sizeUnit, height: uiTheme.sizeUnit)
            }
            .frame(height: uiTheme.sizeUnit * 5)
        }
    }
    
    private var toastTextView: some View {
        let opacity = uiTheme.imageButtonOpacity * toastOpacity
        
        return Text(toastText)
            .foregroundStyle(textTheme.textColor)
            .background(
                RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                    .foregroundStyle(uiTheme.mainColor.opacity(opacity))
                    .padding(.all, -5)
            )
            .frame(maxWidth: .infinity)
    }
    
    //MARK: - Functions
    private func showToast(_ text: String, duration: TimeInterval) {
        toastText = text
        toastOpacity = 1
        
        if let toastTimer {
            toastTimer.invalidate()
            self.toastTimer = nil
        }
        
        toastTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { timer in
            toastOpacity = 0
            self.toastTimer = nil
        }
    }
    
    private func openUrl(to path: String) {
        if let url = URL(string: path), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    MirrorView()
}


fileprivate extension Bool {
    mutating func toggle() {
        self = !self
    }
}
