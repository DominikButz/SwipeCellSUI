//
//  File.swift
//  
//
//  Created by Dominik Butz on 19/10/2020.
//

import Foundation
import SwiftUI

public enum SwipeGroupSide {
    
    var sideFactor: CGFloat {
        switch self {
            case .leading:
                return 1
                
            case .trailing:
                return -1
        }
    }
    
     case leading, trailing

}


public struct SwipeCellActionItem: Identifiable {
    
    public var id: String
    public var buttonView: ()->AnyView
    public var swipeOutButtonView: (()->AnyView)?
    public var buttonWidth: CGFloat
    public var backgroundColor: Color
    public var swipeOutAction: Bool
    public var swipeOutHapticFeedbackType: UINotificationFeedbackGenerator.FeedbackType?
    public var swipeOutIsDestructive: Bool
   // public var swipeOutButtonViewScaleFactor: CGFloat
    public var actionCallback: ()->()
    
    /**
    Initializer
     - Parameter id: Required to identify each buttin in the side menu. Default is a random uuid string.
     - Parameter buttonView: The view in the foreground of the menu button. Make sure to set a maximum frame height less than the cell height!
     - Parameter swipeOutButtonView: Alternative button view that is displayed only when the offset during swipe is beyond the swipe out trigger value. 
     - Parameter  buttonWidth: Width of the button. The the open side menu width is calculated from the sum of all button widths. Default is 75.
     - Parameter backgroundColor: The background colour of the the menu button.
     - Parameter swipeOutAction: A Boolean that determines if a swipe out action is activated or not. Default is false.
    - Parameter swipeOutHapticFeedbackType: If a swipeOutAction is activated, a haptic feedback will occur after the swipe out threshold is passed. Default is nil.
    - Parameter swipeOutIsDestructive: A Boolean that termines if the swipe out is destructive. If true,
    */
    public init(id: String = UUID().uuidString, buttonView: @escaping ()->AnyView, swipeOutButtonView: (()->AnyView)? = nil, buttonWidth: CGFloat = 75, backgroundColor: Color, swipeOutAction: Bool = false, swipeOutHapticFeedbackType: UINotificationFeedbackGenerator.FeedbackType? = nil, swipeOutIsDestructive: Bool = true, actionCallback: @escaping ()->() ){
        self.id = id
        self.buttonView = buttonView
        self.swipeOutButtonView = swipeOutButtonView
        self.buttonWidth = buttonWidth
        self.backgroundColor = backgroundColor
        self.swipeOutAction = swipeOutAction
        self.swipeOutHapticFeedbackType = swipeOutHapticFeedbackType
        self.swipeOutIsDestructive = swipeOutIsDestructive
        self.actionCallback = actionCallback
        
    }

    
}

/// Swipe Cell Settings
public struct SwipeCellSettings {
    /// initializer
    public init(openTriggerValue: CGFloat = 60, swipeOutTriggerRatio: CGFloat =  0.7, addWidthMargin: CGFloat = 5 ){
        self.openTriggerValue = openTriggerValue
        self.swipeOutTriggerRatio = swipeOutTriggerRatio
        self.addWidthMargin = addWidthMargin
    }
    /// minimum horizontal translation value necessary to open the side menu
    public var openTriggerValue: CGFloat
    /// the ratio of the total cell width that triggers a swipe out action (provided one action has swipe out activated)
    public var swipeOutTriggerRatio: CGFloat = 0.7
    /// An additional value to add to the open menu width. This is useful if the cell has rounded corners.
    public var addWidthMargin: CGFloat = 5
}
