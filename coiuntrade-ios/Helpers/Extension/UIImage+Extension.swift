//
//  UIImage+Extension.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/21.
//

import Foundation
import UIKit

extension UIImage{
    /// 将颜色转换为图片
    ///
    /// - Parameter color: UIColor
    /// - Returns: UIImage
    class func getImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}


