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

#endif
