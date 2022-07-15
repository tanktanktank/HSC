//
//  HSCoinDetailVC.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/7/5.
//

import UIKit

class HSCoinDetailVC: BaseViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var scHeaderView: UIView = {
        
        let view = UIView()
        return view
    }()
    
    lazy var scContentView: UIView = {
        
        let view = UIView()
        return view
    }()
    
    lazy var scBottomView: UIView = {
        
        let view = UIView()
        return view
    }()
    
    lazy var bottomView: UIView = {
        
        let view = UIView()
        return view
    }()
}
