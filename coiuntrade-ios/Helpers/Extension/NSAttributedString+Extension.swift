//
//  NSAttributedString+Extension.swift
//  SaaS
//
//  Created by AMYZ0345 on 2021/11/15.
//

import Foundation

extension NSMutableAttributedString {
    
    ///传入字符串、字体      返回NSMutableAttributedString
    static public func appendStrWithString(str:String,font:CGFloat) -> NSMutableAttributedString {
        var attributedString : NSMutableAttributedString
        let attStr = NSMutableAttributedString.init(string: str, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: font)])
        attributedString = NSMutableAttributedString.init(attributedString: attStr)
        return attributedString
    }
    
    //传入字符串、字体、颜色      返回NSMutableAttributedString
    static public func appendColorStrWithString(str:String,font:CGFloat,color:UIColor) -> NSMutableAttributedString {
        var attributedString : NSMutableAttributedString
        let attStr = NSMutableAttributedString.init(string: str, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: font),NSAttributedString.Key.foregroundColor:color])
        attributedString = NSMutableAttributedString.init(attributedString: attStr)
        return attributedString
    }
}
