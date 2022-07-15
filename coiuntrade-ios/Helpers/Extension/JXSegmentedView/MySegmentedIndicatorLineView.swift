//
//  MySegmentedIndicatorLineView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/15.
//

import UIKit

class MySegmentedIndicatorLineView: JXSegmentedIndicatorLineView {
    
    override func selectItem(model: JXSegmentedIndicatorSelectedParams) {
        super.selectItem(model: model)
        
        let targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        var toFrame = self.frame
        if model.currentSelectedIndex == 0 {
            toFrame.size.width = 33
            toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - targetWidth)/2
        }else{
            toFrame.size.width = targetWidth-20
            toFrame.origin.x = model.currentSelectedItemFrame.origin.x + (model.currentSelectedItemFrame.size.width - targetWidth+16)/2
        }
        if canSelectedWithAnimation(model: model) {
            UIView.animate(withDuration: scrollAnimationDuration, delay: 0, options: .curveEaseOut, animations: {
                self.frame = toFrame
            }) { (_) in
            }
        }else {
            frame = toFrame
        }
    }


}
