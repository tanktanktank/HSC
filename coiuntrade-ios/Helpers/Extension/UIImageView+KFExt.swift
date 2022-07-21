//
//  UIImageView+KFExt.swift
//
//
//  Created by  on 2021/12/6.
//

import Kingfisher

#if !os(watchOS)

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension KingfisherWrapper where Base: KFCrossPlatformImageView {
    
    @discardableResult
    public func setImage(with url : String, placeholder : Placeholder?, options : KingfisherOptionsInfo? = [.cacheOriginalImage], completionHandler:((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        let url = URL(string: url)
        return self.setImage(with: url, placeholder: placeholder, options: options, completionHandler: completionHandler)
    }
    
    
}
extension UIImage{
    ///用颜色创建一张图片
   static func creatColorImage(_ color:UIColor,_ ARect:CGRect = CGRect.init(x: 0, y: 0, width: 1, height: 1)) -> UIImage {
        let rect = ARect
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
#endif
