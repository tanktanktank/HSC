//
//  UIButton+Extension.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/5/9.
//

import Foundation

// MARK: - 倒计时
extension UIButton{
    
    public func countDown(count: Int){
        // 倒计时开始,禁止点击事件
        isEnabled = false
        
        // 保存当前的背景颜色
        let defaultColor = self.backgroundColor
        // 设置倒计时,按钮背景颜色
//        backgroundColor = UIColor.gray
        
        var remainingCount: Int = count {
            willSet {
                let attributedString = NSMutableAttributedString.init()//初始化
                attributedString.append(NSMutableAttributedString.appendColorStrWithString(str: ("\(newValue)s"), font: 11, color: .hexColor("FCD283")))
                attributedString.append(NSMutableAttributedString.appendColorStrWithString(str: " 后重新发送", font: 11, color: .hexColor("989898")))
                setAttributedTitle(attributedString, for: .normal)
//                setTitle("重新发送(\(newValue))", for: .normal)
                
                if newValue <= 0 {
                    let attributedString = NSMutableAttributedString.init()//初始化
                    attributedString.append(NSMutableAttributedString.appendColorStrWithString(str: ("tv_send_code".localized()), font: 14, color: .hexColor("FCD283")))
                    setAttributedTitle(attributedString, for: .normal)
//                    setTitle("发送验证码", for: .normal)
                }
            }
        }
        
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.scheduleRepeating(deadline: .now(), interval: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainingCount -= 1
                // 时间到了取消时间源
                if remainingCount <= 0 {
                    self.backgroundColor = defaultColor
                    self.isEnabled = true
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    
}
///扩大button点击范围
class ZQButton:UIButton{
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let zqmargin:CGFloat = -10
        let clickArea = bounds.insetBy(dx: zqmargin, dy: zqmargin)
        return clickArea.contains(point)
    }
}
