//
//  QMUITextField+Ext.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/30.
//

import Foundation

extension QMUITextField {
    ///给UITextField添加一个清除按钮
    func setModifyClearButton() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "trcolse"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(QMUITextField.clear(sender:)), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }
    
    /// 点击清除按钮，清空内容
    @objc func clear(sender: AnyObject) {
        self.text = ""
    }
    
}
