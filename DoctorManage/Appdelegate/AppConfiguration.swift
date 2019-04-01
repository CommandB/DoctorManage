//
//  AppConfiguration.swift
//  DoctorManage
//
//  Created by 黄玮晟 on 2018/9/4.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import Foundation

enum AppConfiguration :String {
    
    ///0=只有学术秘书允许发科室公告 1=带教老师和学术秘书都可以发科室公告
    case teacherCreateNotice = "teacherCreateNotice"
    case teacherCreateNoticeText = "带教老师是否允许发科室公告"
    ///0=不需要 1=需要
    case signInTakePhoto = "signInTakePhoto"
    case signInTakePhotoText = "扫码签到是否需要拍照上传"
    
    ///0=零分 1=满分
    case evaluateDefaultStar = "evaluateDefaultStar"
    case evaluateDefaultStarText = "评价是否默认满分"

    ///web模块配置
    case webModule = "webModeule"
    
    case officeList = "officeList"
    
}
