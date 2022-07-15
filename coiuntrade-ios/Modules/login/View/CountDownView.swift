//
//  CountDownView.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit

/// 倒计时总时长,默认60秒
private let defaultTotal: Int = 60
class CountDownView: UIControl {
    /// 倒计时总时长
    private var countDownTotal = defaultTotal
    /// 倒计时label
    private let countDownLabel = UILabel()
    /// 当前系统绝对时间,进入后台后,仍持续计时
    private var startTime: Int = 0
    /// 定时器对象
    private var taskTimer: DispatchSourceTimer?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 反初始化器
    deinit { print("CCCountDownView deinit~") }
    
    // MARK: - 初始化器
    init() {
        super.init(frame: .zero)
        self.setUI()
    }
    
    // MARK: - UI初始化
    private func setUI() {
        countDownLabel.text = "获取验证码"
        countDownLabel.textColor = .hexColor("FCD283")
        countDownLabel.font = FONTR(size: 11)
        countDownLabel.textAlignment = .center
        addTarget(self, action: #selector(countDownDidSeleted), for: .touchUpInside)
        addSubview(countDownLabel)
        countDownLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - 重置数据
    private func resetData() {
        countDownTotal = defaultTotal
        isUserInteractionEnabled = false
        startTime = Int(CACurrentMediaTime())
    }
    
    // MARK: - 更新UI
    private func updateData() {
        // 获取剩余总时长
        self.countDownTotal = self.remainingTime()
        // 主线程刷新UI
        DispatchQueue.main.async {
            if self.countDownTotal > 0 {
                let attributedString = NSMutableAttributedString.init()//初始化
                attributedString.append(NSMutableAttributedString.appendColorStrWithString(str: (String(self.countDownTotal) + "s"), font: 11, color: .hexColor("FCD283")))
                attributedString.append(NSMutableAttributedString.appendColorStrWithString(str: " 后重新发送", font: 11, color: .hexColor("989898")))
                self.countDownLabel.attributedText = attributedString
            }else {
                self.taskTimer?.cancel()
                self.countDownLabel.text = "重新发送"
                self.countDownLabel.textColor = .hexColor("FCD283")
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    // MARK: - 开始倒计时
    @objc public func countDownDidSeleted() {
        resetData()
        taskTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue(label: "count_down_queue"))
        taskTimer?.schedule(deadline: .now(), repeating: .seconds(1), leeway: .seconds(0))
        taskTimer?.setEventHandler { self.updateData() }
        taskTimer?.resume()
    }
    
    // MARK: - 获取剩余总时长
    private func remainingTime() -> Int {
        defaultTotal - (Int(CACurrentMediaTime()) - startTime)
    }
    
}
