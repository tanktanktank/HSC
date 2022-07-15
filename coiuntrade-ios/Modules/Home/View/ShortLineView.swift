//
//  ShortLineVIew.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/5/9.
//

import UIKit

class  ShortLineView: UIView {
    override init(frame: CGRect) {

        super.init(frame: frame)
        self.backgroundColor = UIColor.clear

    }
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

    }

    override func draw(_ rect: CGRect) {

        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return  }

        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: 10))

        path.addLine(to: CGPoint(x: 30, y: 31))

        let secondP = CGMutablePath()

        secondP.move(to: CGPoint(x: 300, y: 0 ))

        secondP.addLine(to: CGPoint(x: 200, y: 222))

        context.setStrokeColor(UIColor.red.cgColor)


        context.addPath(path)

        context.addPath(secondP)

        context.setLineWidth(2)
        context.strokePath()

    }

}

