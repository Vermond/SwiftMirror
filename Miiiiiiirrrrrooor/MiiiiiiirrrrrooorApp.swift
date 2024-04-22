//
//  MiiiiiiirrrrrooorApp.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 2023/09/19.
//

import SwiftUI

@main
struct MiiiiiiirrrrrooorApp: App {
    @StateObject var uiTheme = UITheme()
    @StateObject var textTheme = TextTheme()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(uiTheme)
                .environmentObject(textTheme)
        }
    }
}
