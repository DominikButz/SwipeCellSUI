//
//  File.swift
//  
//
//  Created by Dominik Butz on 19/10/2020.
//

import Foundation
import SwiftUI

public enum SwipeGroupSide {
     case leading, trailing
}


public struct SwipeCellActionItem: Identifiable {
    
    public var id: String
    public var buttonView: ()->AnyView
    public var width: CGFloat
    public var backgroundColor: Color
    public var swipeOutAction: Bool
    public var swipeOutHapticWarning: Bool
    public var swipeOutIsDestructive: Bool
    public var swipeOutButtonViewScaleFactor: CGFloat
    public var actionCallback: ()->()
    
    public init(id: String = UUID().uuidString, buttonView: @escaping ()->AnyView, itemWidth: CGFloat = 55, backgroundColor: Color, swipeOutAction: Bool = false, swipeOutHapticWarning: Bool = false, swipeOutIsDestructive: Bool = true, swipeOutButtonViewScaleFactor: CGFloat = 2, actionCallback: @escaping ()->() ){
        self.id = id
        self.buttonView = buttonView
        self.width = itemWidth
        self.backgroundColor = backgroundColor
        self.swipeOutAction = swipeOutAction
        self.swipeOutHapticWarning = swipeOutHapticWarning
        self.swipeOutIsDestructive = swipeOutIsDestructive
        self.swipeOutButtonViewScaleFactor = swipeOutButtonViewScaleFactor
        self.actionCallback = actionCallback
        
    }

    
}
