//
//  UIView+Extension.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/20.
//

import Foundation
import UIKit
 
extension UIView {
    
    @discardableResult
    func addGradient(colors: [UIColor],
                     point: (CGPoint, CGPoint) = (CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1)),
                     locations: [NSNumber] = [0, 1],
                     frame: CGRect = CGRect.zero,
                     radius: CGFloat = 0,
                     at: UInt32 = 0) -> CAGradientLayer {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = colors.map { $0.cgColor }
        bgLayer.locations = locations
        if frame == .zero {
            bgLayer.frame = self.bounds
        } else {
            bgLayer.frame = frame
        }
        bgLayer.startPoint = point.0
        bgLayer.endPoint = point.1
        bgLayer.cornerRadius = radius
        self.layer.insertSublayer(bgLayer, at: at)
        return bgLayer
    }
    //将当前视图转为UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

// MARK: - 坐标
extension UIView {
    var x: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var centerX: CGFloat {
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get {
            return self.center.x
        }
    }
    
    var centerY: CGFloat {
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get {
            return self.center.y
        }
    }
    
    var width: CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.height
        }
    }
    
    var size: CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
    
    var origin: CGPoint {
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin
        }
    }
    
    var maxY: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
        get {
            return self.height + self.y
        }
    }
    
    var maxX: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
        get {
            return self.width + self.x
        }
    }
}

// MARK: - 圆角
extension UIView {
    func corner(cornerRadius : CGFloat, toBounds : Bool = true,borderColor : UIColor? = nil, borderWidth : CGFloat? = nil) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor?.cgColor
        if borderWidth != nil  {
            self.layer.borderWidth = borderWidth!
        }
        self.layer.masksToBounds = toBounds
    }
    
    /// 单独圆角
    /// - Parameters:
    ///   - conrners: 圆角枚举
    ///   - radius: 圆角大小
    /// - Returns: <#description#>
    @discardableResult
    func addCorner(conrners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let rect = self.bounds
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        return maskLayer
    }
    
    
}
// MARK: - 弹框消失动画
extension UIView {

    @discardableResult
    func removeTransition() -> CALayer {
        let transition = CATransition()
        let maskLayer = CALayer()
        transition.duration = 1.0
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom 
        maskLayer.add(transition, forKey: nil)
        return maskLayer
    }
    
}

extension UIView {

    @discardableResult
    func addCornerFrame(conrners: UIRectCorner, radius: CGFloat, frame: CGRect) -> CAShapeLayer {
        let rect = frame
        let maskPath = UIBezierPath(roundedRect: rect, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        return maskLayer
    }
    
}
extension UIView{
    //Colors：渐变色色值数组 上下渐变
    func setLayerColors(_ colors:[CGColor])  {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = colors
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        self.layer.addSublayer(layer)
    }
}

public struct UIRectSide : OptionSet {

    public let rawValue: Int

    public static let left = UIRectSide(rawValue: 1 << 0)

    public static let top = UIRectSide(rawValue: 1 << 1)

    public static let right = UIRectSide(rawValue: 1 << 2)

    public static let bottom = UIRectSide(rawValue: 1 << 3)

    public static let all: UIRectSide = [.top, .right, .left, .bottom]

    

    public init(rawValue: Int) {

        self.rawValue = rawValue;

    }

}

extension UIView{
    
    ///画虚线边框

    func drawDashLine(strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 4, lineSpacing: Float = 2.5, corners: UIRectSide) {

            let shapeLayer = CAShapeLayer()

            shapeLayer.bounds = self.bounds
            shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
            shapeLayer.fillColor = UIColor.blue.cgColor
            shapeLayer.strokeColor = strokeColor.cgColor

            shapeLayer.lineWidth = lineWidth
            shapeLayer.lineJoin = .round
            //每一段虚线长度 和 每两段虚线之间的间隔
            shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
            let path = CGMutablePath()
            
            if corners.contains(.left) {
                path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: 0))
            }
            if corners.contains(.top){
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
            }
            if corners.contains(.right){

                path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
            }
            if corners.contains(.bottom){
                path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
                path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
            }
            shapeLayer.path = path
            self.layer.addSublayer(shapeLayer)

        }
}

//extension UIView{
//    ///判断是否是邮箱
//    func checkEmail(email: String) -> Bool {
//        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
//        
//        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//        let isValid = predicate.evaluate(with: email)
//        print(isValid ? "正确的邮箱地址" : "错误的邮箱地址")
//        return isValid
//    }
//    
//    ///判断密码格式
//    func checkPwd(pwd: String) -> Bool {
//        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
//        
//        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//        let isValid = predicate.evaluate(with: pwd)
//        print(isValid ? "正确的密码格式" : "错误的密码格式")
//        return isValid
//    }
//}

extension UITableViewCell {
    
    private func _tableView() -> UITableView? {
        if let tableView = self.superview as? UITableView {
            return tableView
        }
        if let tableView = self.superview?.superview as? UITableView {
            return tableView
        }
        return nil
    }
    
    func addSectionCorner(at indexPath: IndexPath, radius: CGFloat = 10) {
        if let tableView = self._tableView() {
            
            let rows = tableView.numberOfRows(inSection: indexPath.section)
            if indexPath.row == 0 || indexPath.row == rows - 1 {
                var corner: UIRectCorner
                if rows == 1 {
                    corner = UIRectCorner.allCorners
                }else if indexPath.row == 0 {
                    let cornerRawValue = UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue
                    corner = UIRectCorner(rawValue: cornerRawValue)
                }else {
                    let cornerRawValue = UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue
                    corner = UIRectCorner(rawValue: cornerRawValue)
                }
                let cornerLayer = CAShapeLayer()
                cornerLayer.masksToBounds = true
                cornerLayer.frame = self.bounds
                let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
                cornerLayer.path = path.cgPath
                self.layer.mask = cornerLayer
            }else {
                self.layer.mask = nil
            }

        }
    }
    
}
