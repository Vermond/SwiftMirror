//
//  ViewEventType.swift
//  Miiiiiiirrrrrooor
//
//  Created by Jinsu Gu on 4/15/24.
//

import Foundation
import Combine

enum ViewEventType {
    case zoomChanged(rate: CGFloat)
    case offsetChanged(offset: CGPoint)
}

class ViewEventMediator {
    public static var shared = ViewEventMediator()
    
    private let subject = PassthroughSubject<ViewEventType, Never>()
    
    var publisher: AnyPublisher<ViewEventType, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    func sendEvent(_ event: ViewEventType) {
        subject.send(event)
    }
}
