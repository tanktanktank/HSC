//
//  UserCerModel.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/6/28.
//

import UIKit

class UserCerModel: BaseModel {

    ///如果数据返回的是0 则说明没有提交过验证
    var userid = ""
    
    ///姓名
    var name = ""
    
    ///姓氏
    var surname = ""
    
    ///中间名
    var middlename = ""
    
    ///出生日期
    var birthdate = ""
    
    ///国家或地区
    var countryid = ""
    
    ///证件号
    var idcard = ""
    
    ///证件正面
    var idcardimage1 = ""
    
    ///证件反面
    var idcardimage2 = ""
    
    ///视频文件
    var idcardvideo = ""
    
    ///证件类型 1.身份证 2.护照 3.驾照
    var idcardtype = ""
    
    ///审核状态 1.待审核  2.审核失败 3.审核完成
    var idcardstate = ""
    
    ///1.初级认证 2.中级认证 3.高级认证
    var idcardlevel = ""
    
    ///审核类型 1.第三方审核   2.系统审核
    var verifytype = ""
    
    ///区号
    var area = ""
    
    ///驳回原因
    var reason = ""
}



class ReqUserJuniorM: HandyJSON {
    
    var Name: String = ""
    /// 姓氏,非必须
    var Surname: String = ""
    /// 中间名，非必须
    var MiddleName: String = ""
    /// 非必须
    var BirthDate: String = ""
    /// 国家或地区 mock: 40
    var CountryId: Int = 0
    /// 证件类型 1.身份证 2.护照 3.驾照
    var IdCardType: Int = 0
    var IdCard: String = ""

    required init(){}
}



class ReqUserAdvanceM: HandyJSON {
    
    /// 证件正面,必传
    var IdCardImage1: String = ""
    /// 证件背面,必传
    var IdCardImage2: String = ""
    /// 视频文件，必须
    var IdCardVideo: String = ""
    /// 审核类型 1.第三方认证 2.系统认证，必须
    var VerifyType = Int(2)
    /// 视频认证码/非必须
    var VideoCode: String = ""
    /// 人脸识别照1/非必须
    var FaceImage1: String = ""
    /// 人脸识别照2/非必须
    var FaceImage2: String = ""
    
    required init(){}
}
