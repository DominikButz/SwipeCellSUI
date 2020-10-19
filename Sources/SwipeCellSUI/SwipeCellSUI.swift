import Foundation
import SwiftUI




public struct SwipeCellModifier: ViewModifier {
    var cellWidth: CGFloat = UIScreen.main.bounds.width
    var leftSideGroup: [SwipeCellActionItem] = []
    var rightSideGroup: [SwipeCellActionItem] = []
 
    let openTriggerValue: CGFloat = 40
    let swipeOutTriggerRatio: CGFloat = 0.75
    let revealMenuWidth: CGFloat = 160
    let addWidthMargin: CGFloat = 5
    
    @State private var offsetX: CGFloat = 0
    
    let generator = UINotificationFeedbackGenerator()
    
    @State private var openSideLock: SwipeGroupSide?
    
    public func body(content: Content) -> some View {
        ZStack {
            
            if self.leftSideGroup.isEmpty == false {
                self.swipeToRevealArea(swipeItemGroup: self.leftSideGroup, side: .leading)
            }
            
            if self.rightSideGroup.isEmpty == false {
                self.swipeToRevealArea(swipeItemGroup: self.rightSideGroup, side: .trailing)
            }
            
            content
                .offset(x: self.offsetX)
                .gesture(DragGesture().onChanged(self.dragOnChanged(value:)).onEnded(dragOnEnded(value:)))
        }
    }
    
    
    internal func dragOnChanged(value: DragGesture.Value) {
       let horizontalTranslation = value.translation.width
        if self.nonDraggableCondition(horizontalTranslation: horizontalTranslation){
            return
        }
        
        if self.openSideLock != nil {
            
            let factor: CGFloat = self.openSideLock == .leading ? 1 : -1
            self.offsetX = revealMenuWidth * factor + horizontalTranslation
            if self.openSideLock == .leading && horizontalTranslation < -10 || self.openSideLock == .trailing && horizontalTranslation > 10 {
                self.setOffsetX(value: 0)
                self.openSideLock = nil
            }
            return
        }

        
        self.offsetX = horizontalTranslation
    }
    
    
    internal func nonDraggableCondition(horizontalTranslation: CGFloat)->Bool {
        return self.offsetX == 0 && (self.leftSideGroup.isEmpty && horizontalTranslation > 0 || self.rightSideGroup.isEmpty && horizontalTranslation < 0)
    }
    
    internal func dragOnEnded(value: DragGesture.Value) {
//
        if self.leftSideGroup.isEmpty == false{
            if self.offsetX > 0 {
                if self.offsetX.magnitude < openTriggerValue {
                    self.setOffsetX(value: 0)
                    self.openSideLock = nil
                }

                else if let leftItem =  self.leftSideGroup.filter({$0.swipeOutAction == true}).first, self.offsetX.magnitude > self.cellWidth * swipeOutTriggerRatio {
                    if leftItem.swipeOutIsDestructive {
                        self.setOffsetX(value: cellWidth + 10)
                    } else {
                        self.setOffsetX(value: 0)
                    }
                    self.openSideLock = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        leftItem.actionCallback()
                    }
                }

                else {
                    self.setOffsetX(value: revealMenuWidth)
                    self.openSideLock = .leading
                }
            } else if self.rightSideGroup.isEmpty && self.offsetX < 0 {
                self.setOffsetX(value: 0)
                self.openSideLock = nil
            }


        }

        if self.rightSideGroup.isEmpty == false {
            if self.offsetX < 0 {
                if self.offsetX.magnitude < openTriggerValue {
                    self.setOffsetX(value: 0)
                    self.openSideLock = nil
                }

                else if let rightItem = self.rightSideGroup.filter({$0.swipeOutAction == true}).first,  self.offsetX.magnitude > self.cellWidth * swipeOutTriggerRatio {
                    if rightItem.swipeOutIsDestructive {
                        self.setOffsetX(value: -cellWidth - 10)
                    } else {
                        self.setOffsetX(value: 0)
                    }
                    self.openSideLock = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        rightItem.actionCallback()
                    }
                
                    
                }

                else {
                    self.setOffsetX(value: -revealMenuWidth)
                    self.openSideLock = .trailing
                }
            } else if self.leftSideGroup.isEmpty && self.offsetX > 0 {
                self.setOffsetX(value: 0)
                self.openSideLock = nil
            }


        }

    }
    

    
    internal func swipeToRevealArea(swipeItemGroup: [SwipeCellActionItem], side:SwipeGroupSide)->some View {
    
            HStack {
                if side == .trailing {
                    Spacer()
                }
                ZStack {
//                    swipeItem.backgroundColor.frame(width: self.revealAreaWidth(side: side))
                    HStack(spacing:0) {
                    ForEach(swipeItemGroup) { item in
                    
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                self.offsetX = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                item.actionCallback()
                            }
                        } label: {
                            self.itemContentView(item: item, group: swipeItemGroup, side: side)
                        }

                    }
                }
                }.opacity(self.swipeRevealAreaOpacity(side: side))
    
                    if side == .leading {
                        Spacer()
                    }
            }.edgesIgnoringSafeArea(.horizontal)

        
    }
    
    internal func itemContentView(item:SwipeCellActionItem, group: [SwipeCellActionItem], side: SwipeGroupSide)->some View {
        ZStack {
                item.backgroundColor
                
                HStack {
                    Spacer()
                    item.buttonView().scaleEffect(self.warnSwipeOutCondition(side: side, hasSwipeOut: item.swipeOutAction) ? item.swipeOutButtonViewScaleFactor : 1).padding(10).animation(.default)
                        
//                                    .onTapGesture {
//                                        withAnimation(.easeInOut(duration: 0.3)) {
//                                            self.offsetX = 0
//                                        }
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                            item.actionCallback()
//                                        }
//                                    }
                    Spacer()
                }
        }.frame(width: self.itemButtonWidth(item: item, itemGroup: group, side: side))
    }
    
    internal func setOffsetX(value: CGFloat) {
        withAnimation {
            self.offsetX = value
        }
    }

    
    internal func itemButtonWidth(item: SwipeCellActionItem, itemGroup: [SwipeCellActionItem],  side: SwipeGroupSide)->CGFloat {
        let defaultWidth = (self.offsetX.magnitude + addWidthMargin) / CGFloat(itemGroup.count)
        let triggerValue  = self.cellWidth * swipeOutTriggerRatio
        let swipeOutActionCondition = side == .leading ?  self.offsetX > triggerValue  : self.offsetX < -triggerValue
        
        if item.swipeOutAction && swipeOutActionCondition {
            return self.offsetX.magnitude + addWidthMargin
        } else if swipeOutActionCondition && item.swipeOutAction == false && itemGroup.contains(where: {$0.swipeOutAction == true}) {
            return 0
        } else {
            return defaultWidth
        }
        
       // return self.revealAreaWidth(side: side) / CGFloat(swipeItemGroup.count)
    }
    
    internal func warnSwipeOutCondition(side: SwipeGroupSide, hasSwipeOut: Bool)->Bool {
        if hasSwipeOut == false {
            return false
        }
        let triggerValue  = self.cellWidth * swipeOutTriggerRatio
        return (side == .trailing && self.offsetX < -triggerValue) || (side == .leading && self.offsetX > triggerValue)

    }
    
    internal func swipeRevealAreaOpacity(side: SwipeGroupSide)->Double {
        switch side {
        case .leading:
            return self.offsetX > 0 ? 1 : 0
        case .trailing:
           return self.offsetX < 0 ? 1 : 0
        }
    }
}

public extension View {
    
    func swipeCell(cellWidth: CGFloat, leftSideGroup: [SwipeCellActionItem], rightSideGroup: [SwipeCellActionItem])->some View {
        self.modifier(SwipeCellModifier(cellWidth: cellWidth, leftSideGroup: leftSideGroup, rightSideGroup: rightSideGroup))
    }
}
