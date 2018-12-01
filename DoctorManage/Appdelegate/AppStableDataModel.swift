//
//  AppStableDataModel.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/21.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class AppStableDataModel: NSObject {
    func getStableData() {
        let urlString = "http://"+Ip_port2+"doctor_train/rest/app/systemConfigData.do"
        guard let token = UserInfo.instance().token else { return }
        let params = ["token":token]
        Alamofire.request(urlString, method: .post, parameters: params).responseJSON { (response) in
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    let data = json["data"]

                    UserDefaults.AppConfig.set(value: data["教室清单"].description, forKey:.officeList)
                    UserDefaults.AppConfig.set(value: data["投诉功能名称"].description, forKey:.complaintTitle)
                    UserDefaults.AppConfig.set(value: data["教学计划未提报通知时间"].description, forKey: .planNoticeTime)
                    UserDefaults.AppConfig.set(value: data["培训是否默认需要签到"].description, forKey: .trainingIsNeedCheckIn)
                    UserDefaults.AppConfig.set(value: data["教学活动学员评价老师默认评价表"].description, forKey:.teachingActivityS2TEvaluationList)
                    UserDefaults.AppConfig.set(value: data["教学活动老师评价学员默认评价表"].description, forKey:.teachingActivityT2SEvaluationList)
                    UserDefaults.AppConfig.set(value: data["教学计划未提报通知日期"].description, forKey:.planNoticeDate)
                    UserDefaults.AppConfig.set(value: data["客户代码"].description, forKey:.clientCode)
                    UserDefaults.AppConfig.set(value: data["观摩室观看考站编码"].description, forKey:.watchClassroomId)
                    UserDefaults.AppConfig.set(value: data["教学活动类型"].description, forKey:.teachingActivityType)
                    UserDefaults.AppConfig.set(value: data["通用评价表编码"].description, forKey:.publicEvaluationList)
                    UserDefaults.AppConfig.set(value: data["延迟签出分钟数"].description, forKey:.lateCheckOutMinutes)
                    UserDefaults.AppConfig.set(value: data["延迟签到分钟数"].description, forKey:.lateCheckInMinutes)
                    UserDefaults.AppConfig.set(value: data["发布培训通知延时时间（分钟）"].description, forKey:.trainingDelayNoticeMinutes)
                    UserDefaults.AppConfig.set(value: data["带教老师是否允许发科室公告"].description, forKey:.teacherAllowCreateDeptNotice)
                    UserDefaults.AppConfig.set(value: data["扫码签到是否需要拍照上传"].description, forKey:.scanCheckInTakePhoto)
                    UserDefaults.AppConfig.set(value: data["是否学员"].description, forKey:.isStudent)
                    UserDefaults.AppConfig.set(value: data["是否老师"].description, forKey:.isTeacher)
                    UserDefaults.AppConfig.set(value: data["是否秘书"].description, forKey:.isSecretary)
                    UserDefaults.AppConfig.set(value: data["签到机扫码拍照"].description, forKey:.checkInMachineTakePhoto)
                    UserDefaults.AppConfig.set(value: data["二维码失效时间"].description, forKey:.qrCodeExpireTime)
                    UserDefaults.AppConfig.set(value: data["科室清单"].description, forKey:.officeList)
                    
                    UserDefaults.AppConfig.set(value: data["科室清单"].description, forKey:.officeList)
                    UserDefaults.AppConfig.set(value: data["教室清单"].description, forKey:.classroomList)
                    UserDefaults.AppConfig.set(value: data["评价表清单"].description, forKey:.teachingActivityEvaluationList)
                    UserDefaults.AppConfig.set(value: data["是否开启Mini-CEX"].description, forKey:.isOpenMiniCex)
//                    if let officeList = UserDefaults.AppConfig.any(forKey: .officeList) as? [[String:String]] {
//                        print(officeList)
//                    }
//
//                    guard let description = UserDefaults.AppConfig.string(forKey: .officeList) else { return }
//                    let json2 = JSON(description)
//                    print(json2.arrayValue)
                }else{
                    print("error")
                }
            }
        }
        
        
        
    }
}
