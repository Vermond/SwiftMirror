//
//  MirrorView+CommomItems.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 3/21/24.
//

import Foundation
import SwiftUI
import MessageUI

//MARK: - Info Views
extension MirrorView {
    internal var infoButton: some View {
        Button(action: {
            isInfoHidden.toggle()
        }) {
            Image(systemName: "info.circle.fill")
                .scaleEffect(2.2)
                .foregroundStyle(uiTheme.mainImageButtonBackground)
                .frame(width: uiTheme.sizeUnit, height: uiTheme.sizeUnit)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .background(
            mainCircleOutline
                .frame(maxWidth: .infinity, alignment: .trailing)
        )
    }
    
    internal var infoView: some View {
        GeometryReader { gr in
            let maxWidth = gr.size.width * 0.4
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            let unit = uiTheme.paddingUnit
            
            VStack {
                infoText(text: "Ver. \(appVersion ?? "-")", maxWidth: maxWidth, unit: unit)
                
                infoText(text: "⌾ Develop by\nJinsu Gu", maxWidth: maxWidth, unit: unit)
                
                if MFMailComposeViewController.canSendMail() {
                    Button(action: {
                        self.isShowingMailView.toggle()
                    }, label: {
                        Text("Mail to me")
                            .frame(maxWidth: maxWidth, alignment: .trailing)
                            .padding(.trailing, unit)
                    })
                } else {
                    Text("\(mail)")
                        .frame(maxWidth: maxWidth, alignment: .trailing)
                        .padding(.trailing, unit)
                }
                
                infoText(text: "⌾ Icon by Freepik\nfrom Flaticon", maxWidth: maxWidth, unit: unit)
                
                Button(action: {
                    let web = "https://www.flaticon.com/"
                    openUrl(to: web)
                }, label: {
                    Text("Go to Flaticon")
                        .frame(maxWidth: maxWidth, alignment: .trailing)
                        .padding(.trailing, unit)
                        .padding(.bottom, unit)
                })
                
                infoText(text: "⌾ Cat Image\nby Dim Hou\nfrom Unsplash", maxWidth: maxWidth, unit: unit)
                
                Button(action: {
                    let web = "https://pixabay.com/users/dimhou-5987327/"
                    openUrl(to: web)
                }, label: {
                    Text("Go to Unsplash")
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
}
    
//MARK: - Zoom Views
extension MirrorView {
    internal var currentZoomButton: some View {
        Button(action: {
            isZoomHidden.toggle()
        }, label: {
            Text("x \(textTheme.numberToString(model.zoomRate))")
                .scaleEffect(textTheme.textScaleRate)
                .foregroundStyle(textTheme.textColor)
                .frame(width: uiTheme.sizeUnit * 1.75, height: uiTheme.sizeUnit)
        })
        .background(mainSquareButton)
        
    }
    
    internal var zoomChangeView: some View {
        HStack {
            VerticalSliderView(value: model.zoomRateBinding, valueRange: model.zoomRange)
                .frame(width: uiTheme.sizeUnit, height: uiTheme.sizeUnit * 5)
            
            VStack {
                zoomLabelButton(zoomRate: model.zoomRange.upperBound)
                Spacer()
                zoomLabelButton(zoomRate: model.zoomRange.middleBound)
                Spacer()
                zoomLabelButton(zoomRate: model.zoomRange.lowerBound)
            }
            .frame(height: uiTheme.sizeUnit * 5)
        }
    }
}

//MARK: - Filter views
extension MirrorView {
    internal var filterMainButton: some View {
        Button(action: {
            isFilterListHidden.toggle()
        }, label: {
            Image(currentFilter.rawValue)
                .resizable()
                .frame(width: uiTheme.sizeUnit, height: uiTheme.sizeUnit)
        })
    }
    
    internal var filterSelectList: some View {
        ScrollView {
            VStack(spacing: 25) {
                ForEach(Filters.allCases, id: \.self) { filter in
                    Button(action: {
                        self.currentFilter = filter
                    }, label: {
                        Image(filter.rawValue)
                            .resizable()
                            .frame(width: uiTheme.sizeUnit * 1.25, height: uiTheme.sizeUnit * 1.25)
                    })
                    .offset(x: 0)
                }
            }
            .padding()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                .foregroundStyle(uiTheme.mainColor.opacity(uiTheme.imageButtonOpacity * 0.5))
        )
    }
}

//MARK: - Other views
extension MirrorView {
    internal var takePictureButton: some View {
        Button(action: {
            isWaitingForCapture = true
        }) {
            Circle()
                .stroke()
                .foregroundStyle(uiTheme.mainColor)
                .frame(width: uiTheme.sizeUnit * 1.15)
                .background(
                    mainCircleOutline
                        .background(
                            Circle().foregroundStyle(uiTheme.mainImageButtonBackground)
                        )
                )
        }
    }
    
    internal var hideUIButton: some View {
        Button(action: {
            isUIHidden = true
        }, label: {
            Text("Hide UI")
                .scaleEffect(textTheme.textScaleRate)
                .foregroundStyle(textTheme.textColor)
                .frame(width: uiTheme.sizeUnit * 1.75, height: uiTheme.sizeUnit)
        })
        .background(mainSquareButton)
    }
    
    internal var toastTextView: some View {
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
}

//MARK: - Commom Views
extension MirrorView {
    internal var mainSquareButton: some View {
        RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
            .stroke()
            .foregroundStyle(uiTheme.mainColor)
            .background(
                RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                    .foregroundStyle(uiTheme.mainImageButtonBackground)
            )
    }
    
    internal var mainCircleOutline: some View {
        Circle()
            .stroke()
            .frame(width: uiTheme.sizeUnit)
            .foregroundStyle(uiTheme.mainColor)
    }
    
    internal func infoText(text: String, maxWidth: CGFloat, unit: CGFloat) -> some View {
        Text(text)
            .frame(maxWidth: maxWidth, alignment: .trailing)
            .foregroundStyle(textTheme.textColor)
            .multilineTextAlignment(.trailing)
            .padding(.trailing, unit)
            .padding(.top, unit)
    }
    
    internal func zoomText(text: String) -> some View {
        Text(text)
            .foregroundStyle(textTheme.textColor)
            .frame(width: uiTheme.sizeUnit, height: uiTheme.sizeUnit)
            .background(
                RoundedRectangle(cornerRadius: uiTheme.cornerRadius)
                    .foregroundStyle(uiTheme.mainColor.opacity(uiTheme.imageButtonOpacity * 0.5))
                    .padding(.horizontal, -10)
            )
    }
    
    internal func zoomLabelButton(zoomRate: CGFloat) -> some View {
        Button(action: {
            model.setZoomRate(zoomRate)
        }, label: {
            zoomText(text: "x\(textTheme.numberToString(zoomRate))")
        })
    }
}
