//
//  FilterMainButton.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI

struct FilterMainButton: View {
    @EnvironmentObject internal var uiTheme: UITheme
    
    @Binding var isFilterListHidden: Bool
    @Binding var filter: Filters
    
    var body: some View {
        Button(action: {
            isFilterListHidden.toggle()
        }, label: {
            Image(filter.rawValue)
                .resizable()
                .frame(width: uiTheme.sizeUnit, height: uiTheme.sizeUnit)
        })
    }
}

#Preview {
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    
    @State var isFilterListHidden = false
    @State var filter = Filters.None
    
    return FilterMainButton(isFilterListHidden: $isFilterListHidden, filter: $filter)
        .environmentObject(uiTheme)
}
