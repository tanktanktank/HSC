//
//  CustomEmptyDataState.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/6/23.
//

import UIKit

enum CustomEmptyDataState: XYEmptyDataState {
    /// 无本数据
    case noData
    /// 添加自选
    case addLike
    /// 无消息
    case noMessage
    /// 无网络
    case noInternet
    case error(Error)
    /// 加载中
    case loading
    /// 提交成功
    case submitSuccess
    
    var title: ((UILabel) -> Void)? {
        return {
            switch self {
            case .noData:
                $0.text = nil
            default:
                return $0.text = ""
            }
        }
    }
    
    var detail: ((UILabel) -> Void)? {
        return {
            $0.numberOfLines = 0
            switch self {
            case .noData:
                $0.font = FONTR(size: 11)
                $0.textColor = .hexColor("989898")
                $0.text = "tv_empty_data".localized()
            default:
                return $0.text = ""
            }
        }
    }
    
    var button: ((UIButton) -> Void)? {
        return {
            switch self {
            case .addLike:
//                $0.size = CGSize(width: 114, height: 40)
                $0.corner(cornerRadius: 2, toBounds: true, borderColor: UIColor.hexColor("FCD283"), borderWidth: 1)
                $0.setTitle("tv_market_add_optional".localized(), for: .normal)
                $0.setTitleColor(UIColor.hexColor("FCD283"), for: .normal)
                $0.titleLabel?.font = FONTM(size: 14)
                $0.setImage(UIImage(named: "marke_addlike"), for: .normal)
            default:
                $0.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
                $0.layer.cornerRadius = 5.0
                $0.layer.masksToBounds = true
                $0.setTitle(nil, for: .normal)
            }
        }
    }
    
    var image: ((UIImageView) -> Void)? {
        return {
            switch self {
            case .noData:
                $0.image = UIImage(named: "nodata")
            default:
                $0.image = nil
            }
        }
    }
    
    var customView: UIView? {
        switch self {
        case .loading:
            let indicatorView = UIActivityIndicatorView(style: .gray)
            indicatorView.startAnimating()
            return indicatorView
        default:
            return nil
        }
    }
}
