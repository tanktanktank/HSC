//
//  Array+Safe.swift
//  SaaS
//
//  Created by 袁涛 on 2021/10/27.
//

import UIKit

// MARK: - 查找
extension Array {
    
    func safeObject(index : Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}

// MARK: - 插入
extension Array {
    
    /// 插入是否成功
    /// - Parameters:
    ///   - newElement: 插入对象
    ///   - i: 插入位置
    /// - Returns: 返回成功或者失败
    @discardableResult
    mutating func safeInsert(newElement : Element, at i : Int) -> Bool {
        
        if !indices.contains(i) { /// 位置不存在
            
//            Logger.debugPrint("newElement Insert point out of bounds, object::\(newElement.self), Object Type::\(Element.self)")
            return false
        }
                
        insert(newElement, at: i)
        return true
    }
}

// MARK: - 修改
extension Array {
    
    /// 替换是否成功
    /// - Parameters:
    ///   - newElements: 替换数组
    ///   - i: 起始元素坐标
    ///   - offset: 偏移量
    /// - Returns: 是否替换成功
    @discardableResult
    mutating func safeReplace(newElements : [Element], at i : UInt, offset : UInt = 0) -> Bool {
        
        let start = Int(i)
        let end = Int((offset + i))
        
        if !indices.contains(start) || !indices.contains(end)   {
//            Logger.debugPrint("Fatal error: Array replace: subrange extends past the end, newElements::\(newElements)")
            return false
        }

        replaceSubrange(start...end, with: newElements)
        return true
    }
}

// MARK: -  删除
extension Array {
    
    @discardableResult
    mutating func safeRemove(at i : Int) -> (element: Element?, success : Bool) {
        if !indices.contains(i) {
            return (nil,false)
        }
        return (remove(at: i), true)
    }
    
}


extension Collection  {
    subscript(safe index : Self.Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
