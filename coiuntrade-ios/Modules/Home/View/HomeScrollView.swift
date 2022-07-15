//
//  HomeScrollView.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/20.
//

import UIKit
import OYMarqueeView

class HomeScrollTextView: OYMarqueeViewItem {
    
    var text: String = "" {
        didSet {
            textLabel.text = text
        }
    }
    var textIndex: String = "" {
        didSet {
            indexLabel.text = textIndex
        }
    }
    
    var ups: Bool = false {
        didSet {
            imgView.image = ups == false ? UIImage(named: "green") : UIImage(named: "red")
        }
    }
    
    lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.font = FONTR(size: 11)
        label.numberOfLines = 0
        return label
    }()
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = FONTR(size: 11)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var imgView: UIImageView = UIImageView()
    
    
    required init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        imgView.contentMode = .scaleAspectFit
        addSubview(indexLabel)
        addSubview(textLabel)
        addSubview(imgView)
        indexLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview().offset(0)
        }
        textLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().offset(0)
            make.left.equalTo(indexLabel.snp.right).offset(2)
        }
        imgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(0)
            make.width.equalTo(8)
            make.height.equalTo(8)
            make.left.equalTo(textLabel.snp.right).offset(5)
        }
    }
}
