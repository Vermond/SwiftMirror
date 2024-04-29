//
//  FilterSelectList.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/29/24.
//

import SwiftUI

struct FilterSelectList: View {
    @EnvironmentObject internal var uiTheme: UITheme
    
    @Binding var filter: Filters
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                ForEach(Filters.allCases, id: \.self) { filter in
                    Button(action: {
                        self.filter = filter
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

#Preview {
    let uiTheme = ThemePreview.WhitePreview.uiTheme
    
    @State var filter = Filters.None
    
    return FilterSelectList(filter: $filter)
        .environmentObject(uiTheme)
}
