//
//  Global.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/29.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//MARK:IP地址
let Ip_port = "139.224.207.29:8086"
//let Ip_port2 = "58.100.106.140:80/"
//var Ip_port2 = "120.77.181.22:80/"
var Ip_port2 = "218.109.193.102/"


//MARK: 屏幕尺寸
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height

//MARK: 接口
let kSelectbaseURL = "http://139.224.207.29:8086/doctor_train/rest/trainHospital/query.do"

let kLoginURL = "doctor_portal/rest/loginCheck.do"

//***********任务中心
//MARK: 未开始任务
let kUnCompleteTaskURL = "doctor_train/rest/task/queryTeacherTask.do"
let kTaskDetailURL = "doctor_train/rest/task/queryTaskAllPerson.do"
//MARK: 签到
let kRecordTaskSignResultURL = "doctor_train/rest/taskSignResult/recordTaskSignResult.do"
//MARK: 评价
let kQueryTaskevaluationresultinfoRateURL = "doctor_train/rest/evaluation/queryTaskevaluationresultinfoRate.do"

//**********学员
//MARK: 我的学员--个人信息(全部)
let kQueryMyStudentsURL = "doctor_train/rest/teacher/queryMyStudents.do"
//MARK: 我的学员--心愿单
let kQueryStudentWishListURL = "doctor_train/rest/wishList/queryFromTeacher.do"
//MARK: 我的学员--轮转
let kQueryStudentOutlineByTeacherURL = "doctor_train/rest/outline/queryStudentOutlineByTeacher.do"
//MARK: 我的学员--任务
let kQueryStudentTaskURL = "doctor_train/rest/task/queryFromTeacher.do"
//MARK: 缺勤
let kUpdateStudentWorkStateURL = "doctor_train/rest/task/updateStudentWorkState.do"

//***********
//MARK: 待考任务
let kQueryTaskExamURL = "doctor_train/rest/taskexam/queryTeacherTask.do"
//MARK: 待评任务
let kQueryTaskEvaluationURL = "doctor_train/rest/taskEvaluation/queryTeacherTask.do"
//MARK: 查询评价详情（星星）
let kQueryTaskStarURL = "doctor_train/rest/evaluation/query.do"
//MARK: 提交评价（星星）
let kCommitEvaluationResultURL = "doctor_train/rest/evaluation/commitEvaluationResult.do"
//MARK: 出科考试
let kQueryExercisesInfoURl = "doctor_train/rest/exercises/queryExercisesInfo.do"
//MARK: 考试中
let kSkillQuestionURl = "doctor_train/rest/skillQuestion/querySkillquestions.do"
//MARK: 技能考题细项
let kQuerySkillquestionsitem = "doctor_train/rest/skillQuestion/querySkillquestionsitem.do"



//***********
//MARK: 我的信息
let kMyInfoURL = "doctor_train/rest/personTeacher/query.do"
//MARK: 评价明细
let kMyEvaluateDetailURL = "doctor_train/rest/taskexam/queryTeacherTask.do"
//MARK: 在线问题
let kOnlineQuestionURL = "doctor_train/rest/difficult/queryByOffice.do"
//MARK: 我的页面评价明细
let kMyEvalueDetailURL = "doctor_train/rest/taskEvaluationResult/queryTeacherResult.do"

let kUploadVideoSuccessNotification = "uploadVideoSuccessNotification"


//MARK:Notification

let kLoginSuccessNotification = "kLoginSuccessNotification"

//MARK: 数据是否请求成功
func iSRequestSuccess(data:[String:String]) -> Bool {
    if data["code"] == "1" {
        return true
    }
    return false
}

//MARK: 判断是否有网络
func iSReachable() -> Bool{
    let reachable = Reachability.forInternetConnection().isReachable()
    return reachable
}

//MARK: 计算label长度
func getLabWidth(labelStr:String,font:CGFloat,height:CGFloat) -> CGFloat {
    let statusLabelText: NSString = NSString(string: labelStr)
    let size = CGSize.init(width: 900, height: height)
    let dic = NSDictionary(object: UIFont.systemFont(ofSize: font), forKey: NSFontAttributeName as NSCopying)
    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
    return strSize.width+20
    
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
}

