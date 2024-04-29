//
//  InfoView.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI
import MessageUI

struct InfoView: View {
    @EnvironmentObject internal var uiTheme: UITheme
    @State var mail: String
    @Binding var mailToggle: Bool
    
    var body: some View {
        GeometryReader { gr in
            let maxWidth = gr.size.width * 0.4
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            let unit = uiTheme.paddingUnit
            
            VStack {
                InfoText(text: "Ver. \(appVersion ?? "-")", maxWidth: maxWidth, unit: unit)
                
                InfoText(text: "⌾ Develop by\nJinsu Gu", maxWidth: maxWidth, unit: unit)
                
                if MFMailComposeViewController.canSendMail() {
                    Button(action: {
                        mailToggle.toggle()
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
                
                InfoText(text: "⌾ Icon by Freepik\nfrom Flaticon", maxWidth: maxWidth, unit: unit)
                
                Button(action: {
                    let web = "https://www.flaticon.com/"
                    openUrl(to: web)
                }, label: {
                    Text("Go to Flaticon")
                        .frame(maxWidth: maxWidth, alignment: .trailing)
                        .padding(.trailing, unit)
                        .padding(.bottom, unit)
                })
                
                InfoText(text: "⌾ Cat Image\nby Dim Hou\nfrom Unsplash", maxWidth: maxWidth, unit: unit)
                
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

extension InfoView {
    private func openUrl(to path: String) {
        if let url = URL(string: path), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    let textTheme = ThemePreview.WhitePreview.textTheme
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    
    @State var toggle = true
    
    return InfoView(mail: "mail@to.me", mailToggle: $toggle)
        .environmentObject(textTheme)
        .environmentObject(uiTheme)
}
