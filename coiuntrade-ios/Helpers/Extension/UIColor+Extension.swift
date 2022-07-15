//
//  UIColor+Extension.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/19.
//

import UIKit


enum GradientDirections {
   case Right
   case Left
   case Bottom
   case Top
   case TopLeftToBottomRight
   case TopRightToBottomLeft
   case BottomLeftToTopRight
   case BottomRightToTopLeft
}
extension UIColor {

    /// 颜色
    ///
    /// - Parameters:
    ///   - r: red
    ///   - g: green
    ///   - b: blue
    /// - Returns: UIColor
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    /// 颜色
    ///
    /// - Parameters:
    ///   - hexColor: 十六进制码
   /// - Returns: UIColor
    class func HexColor(_ hexColor: Int32 ) -> UIColor {
        let r = CGFloat(((hexColor & 0x00FF0000) >> 16)) / 255.0
        let g = CGFloat(((hexColor & 0x0000FF00) >> 8)) / 255.0
        let b = CGFloat(hexColor & 0x000000FF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    
    ///随机色
       class var random:UIColor {
           return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1)
       }
    /// 通过哈希值返回颜色
    ///
    /// - Parameter hexColor: 哈希值
    /// - Returns: <#return value description#>
    class func Ahex8(_ hexColor:Int) ->UIColor {
        let alpha = CGFloat((hexColor & 0xFF000000) >> 24)/255.0
        let red = CGFloat((hexColor & 0xFF0000) >> 16)/255.0
        let green = CGFloat((hexColor & 0xFF00) >> 8)/255.0
        let blue = CGFloat(hexColor & 0xFF)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
       /// 通过哈希值返回颜色
       /// 通过哈希值返回颜色
       ///
       /// - Parameter hexColor: 哈希值
       /// - Returns: <#return value description#>
       class func hexColor(_ hexColor:Int) ->UIColor {
           let red = CGFloat((hexColor & 0xFF0000) >> 16)/255.0
           let green = CGFloat((hexColor & 0xFF00) >> 8)/255.0
           let blue = CGFloat(hexColor & 0xFF)/255.0
           return UIColor(red: red, green: green, blue: blue, alpha: 1)
       }
       
       /// 通过哈希值字符返回颜色
       ///
       /// - Parameter hexColor: 哈希值字符
       /// - Parameter alpha: 透明度
       /// - Returns: <#return value description#>
       class func hexColor(_ hexColor:String ,alpha:CGFloat = 1) ->UIColor {
           var cString = hexColor.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
           // 去掉前缀
           if cString.hasPrefix("0X") {
               let start = cString.index(cString.startIndex, offsetBy: 2)
               cString = String(cString[start..<cString.endIndex])
           }
           if cString.hasPrefix("#") {
               let start = cString.index(cString.startIndex, offsetBy: 1)
               cString = String(cString[start..<cString.endIndex])
           }
           
           guard cString.count == 6 else {
               return .black
           }
           var redStr:String = ""
           var greenStr:String = ""
           var blueStr:String = ""
           for i in 0...2 {
               let start = cString.index(cString.startIndex, offsetBy: i * 2)
               let end = cString.index(start, offsetBy: 2)
               if i == 0 {
                   redStr = String(cString[start..<end])
               }else if i == 1 {
                   greenStr = String(cString[start..<end])
               }else{
                   blueStr = String(cString[start..<end])
               }
           }
           var r:UInt64 = 0
           Scanner(string: redStr).scanHexInt64(&r)
           var g:UInt64 = 0
           Scanner(string: greenStr).scanHexInt64(&g)
           var b:UInt64 = 0
           Scanner(string: blueStr).scanHexInt64(&b)
           return UIColor(red: CGFloat(r)/255.0, green:  CGFloat(g)/255.0, blue:  CGFloat(b)/255.0, alpha: alpha)
       }
    
    class func imageFromColor(color: UIColor, viewSize: CGSize) -> UIImage{
            let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
            
            UIGraphicsBeginImageContext(rect.size)
            
            let context: CGContext = UIGraphicsGetCurrentContext()!
            context.setFillColor(color.cgColor)
            context.fill(rect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsGetCurrentContext()
            return image!
    }
    
    class func gradientColor(_ direction : GradientDirections,_ targeView :UIView, _ colors: [Any])-> UIColor{
        // 外界如果改变了self的大小，需要先刷新
        targeView.layoutIfNeeded()
        var endPoint = CGPoint.zero
        let targetSize = targeView.frame.size
        var size = targetSize
        if direction == .Right {
            size = CGSize(width: targetSize.width, height: 1)
            endPoint = CGPoint(x: targetSize.width, y:0)
        }
        if direction == .Bottom {
            size = CGSize(width: 1, height: targetSize.height)
            endPoint = CGPoint(x: 0, y: targetSize.height)
           
        }
        if targetSize == .zero {
            return clear
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradient.init(colorsSpace: colorspace, colors: colors as CFArray, locations:nil )
        context?.drawLinearGradient(gradient!, start: CGPoint.zero, end: endPoint, options: [])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
//        Co
//        CoreGraphics.CGColorSpaceRelease
//        CGColorSpaceRelease(colorspace);
        UIGraphicsEndImageContext()
//        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), endPoint, 0)
        return UIColor.init(patternImage: image!)
    }
}

