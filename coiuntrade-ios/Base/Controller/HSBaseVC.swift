//
//  HSBaseVC.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/7/13.
//

import UIKit

class HSBaseVC: UIViewController {

    var isHiddenStatrsBarHidden : Bool = false
    
    lazy var titleLab : UILabel = {
        let lab = UILabel()
        lab.textColor = .hexColor("FFFFFF")
        lab.font = FONTB(size: 22)
        return lab
    }()
    
    func setupEmptyDataView(type : CustomEmptyDataState) -> XYEmptyData {
        switch type {
        case .noData:
            var emptyData = XYEmptyData.with(state: CustomEmptyDataState.noData)
            emptyData.format.contentEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
            emptyData.format.imageSize = CGSize(width: 140, height: 90)
            emptyData.format.itemPadding = 25
            return emptyData
        case .addLike:
            var emptyData = XYEmptyData.with(state: CustomEmptyDataState.addLike)
            emptyData.delegate = self
//            emptyData.format.contentEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
            emptyData.format.contentEdgeInsets = UIEdgeInsets(top: 0, left: (SCREEN_WIDTH-114-23*2)/2.0, bottom: 0, right: (SCREEN_WIDTH-114-23*2)/2.0)
            emptyData.format.itemPadding = 0
            return emptyData
        default:
            var emptyData = XYEmptyData.with(state: CustomEmptyDataState.noData)
            emptyData.format.contentEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
            emptyData.format.imageSize = CGSize(width: 140, height: 90)
            emptyData.format.itemPadding = 25
            return emptyData
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.init()
        
        self.view.backgroundColor = .hexColor("1E1E1E")
        self.view.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(LR_Margin)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(30)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("控制器销毁😁 --\(NSStringFromClass(type(of: self)))")
    }

}

extension HSBaseVC : XYEmptyDataDelegate{
    
    /// 点击空视图的`button`按钮的回调
    func emptyData(_ emptyData: XYEmptyData, didTapButtonInState state: XYEmptyDataState){
        print("button`按钮的回调")
    }
    /// 点击空视图的`contentView`回调
    func emptyData(_ emptyData: XYEmptyData, didTapContentViewInState state: XYEmptyDataState){
        print("contentView`按钮的回调")
        
    }
}
