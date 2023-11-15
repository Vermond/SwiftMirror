//
//  ClosedRange+Extension.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 11/15/23.
//

import Foundation

extension ClosedRange<CGFloat> {
    var middleBound: CGFloat {
        (self.upperBound - self.lowerBound) / 2 + self.lowerBound
    }
}
