 //
//  NetworkTools.swift
//  jisoshi5
//
//  Created by chenhaifeng  on 2017/6/28.
//  Copyright © 2017年 chenhaifeng . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
extension String {
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
enum MethodType {
    case get
    case post
}

class NetworkTool: NSObject {
    static let sharedInstance = NetworkTool()
    var r_param = ["myshop_forapp_key":"987654321","fromteacher":"1"]
    var r_token = "";
    
    private override init() {
        super.init()
    }

    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback :  @escaping (_ result : Any) -> ()) {
        
        // 1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            // 4.将结果回调出去
            finishedCallback(result)
        }
    }
    
    //MARK: 请求基地
    func requestBase(params : [String : Any],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        Alamofire.request(kSelectbaseURL, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    _ = JSON(value)
                    //                    PrintLog(json)
                }
            case .failure(let error):
                failture(error)
                //                PrintLog("error:\(error)")
            }
            
        }
    }
    
    //MARK: 登录
    class func login(params : [String : String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
//        let portalurl = UserDefaults.standard.string(forKey: "portalurl")
        let urlString = "http://" + params["baseportalurl"]! + "/" + kLoginURL
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
//                    let json = JSON(value)
                }
            case .failure(let error):
                failture(error)
            }
            
        }
    }
    
    //MARK: 未开始任务
    func requestUnCompleteTask(params : [String : String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        let urlString = "http://"+Ip_port2+kUnCompleteTaskURL
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    _ = JSON(value)
                    //                    PrintLog(json)
                }
            case .failure(let error):
                failture(error)
                //                PrintLog("error:\(error)")
            }
            
        }
    }
    
    //MARK: 任务明细
    func requestTaskDetail(params : [String : String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        let urlString = "http://"+Ip_port2+kTaskDetailURL
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    _ = JSON(value)
                    //                    PrintLog(json)
                }
            case .failure(let error):
                failture(error)
                //                PrintLog("error:\(error)")
            }
            
        }
    }
    
    //MARK: 签到
    func requestRecordTaskSignResult(params : [String : String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        let urlString = "http://"+Ip_port2+kRecordTaskSignResultURL
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    _ = JSON(value)
                    //                    PrintLog(json)
                }
            case .failure(let error):
                failture(error)
                //                PrintLog("error:\(error)")
            }
            
        }
    }
    
    //MARK: 我的学员--个人信息(全部)
    func requestQueryMyStudentsURL(params : [String : String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        let urlString = "http://"+Ip_port2+kQueryMyStudentsURL
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    let json = JSON(value)
                    print("json--\(json)")
                }
            case .failure(let error):
                failture(error)
                //                PrintLog("error:\(error)")
            }
            
        }
    }

    //MARK: 我的学员--心愿单
    func requestQueryStudentWishListURL(params : [String : String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        let urlString = "http://"+Ip_port2+kQueryStudentWishListURL
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    let json = JSON(value)
                    print("json--\(json)")
                }
            case .failure(let error):
                failture(error)
            }
            
        }
    }
    
    //MARK: 我的学员--轮转
    func requestQueryStudentOutlineByTeacherURL(params : [String : String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        let urlString = "http://"+Ip_port2+kQueryStudentOutlineByTeacherURL
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    let json = JSON(value)
                    print("轮转json--\(json)")
                }
            case .failure(let error):
                failture(error)
                //                PrintLog("error:\(error)")
            }
            
        }
    }
    
    //MARK: 我的学员--任务
    func requestQueryStudentTaskURL(params : [String : String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        let urlString = "http://"+Ip_port2+kQueryStudentTaskURL
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    let json = JSON(value)
                }
            case .failure(let error):
                failture(error)
            }
            
        }
    }
    
    //MARK: 我的学员--缺勤
    func requestUpdateStudentWorkStateURL(params : [String : String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        let urlString = "http://"+Ip_port2+kUpdateStudentWorkStateURL
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    let json = JSON(value)
                }
            case .failure(let error):
                failture(error)
            }
            
        }
    }
    
    //MARK: 我的学员--全部
//    func requestQueryStudentTaskURL(params : [String : Any],success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()) {
//        let urlString = "http://"+"139.224.207.29:8086/"+kQueryStudentTaskURL
//        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
//            switch response.result{
//            case .success:
//                if let value = response.result.value as? [String: AnyObject] {
//                    success(value)
//                    let json = JSON(value)
//                }
//            case .failure(let error):
//                failture(error)
//            }
//            
//        }
//    }

//******考评
    //MARK: 待考任务
    func requestTaskexamURL(params : [String : Any],success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()) {
        let urlString = "http://"+Ip_port2+kQueryTaskExamURL
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    let json = JSON(value)
                }
            case .failure(let error):
                failture(error)
            }
            
        }
    }
    
    //MARK: 待评任务
    func requestTaskEvaluationURL(params : [String : Any],success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()) {
        let urlString = "http://"+Ip_port2+kQueryTaskEvaluationURL
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    let json = JSON(value)
                }
            case .failure(let error):
                failture(error)
            }
            
        }
    }
//******我的
    //MARK: 我的信息
    func requestMyInfoURL(params : [String : Any],success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()) {
        let urlString = "http://"+Ip_port2+kMyInfoURL
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    let json = JSON(value)
                }
            case .failure(let error):
                failture(error)
            }
            
        }
    }
    
    //MARK: 我的信息
    func requestOnlineQuestionURL(params : [String : Any],success : @escaping (_ response : [String : Any])->(), failture : @escaping (_ error : Error)->()) {
        let urlString = "http://"+Ip_port2+kOnlineQuestionURL
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    let json = JSON(value)
                }
            case .failure(let error):
                failture(error)
            }
            
        }
    }
    
    //post方式提交数据
    func myPostRequest(_ url:String, _ parameters: [String: Any]? = nil , method: HTTPMethod = HTTPMethod.post) -> DataRequest {
        
        let paramData = NSMutableDictionary()
        
        //合并默认参数和用户请求的参数
        if parameters != nil{
            paramData.addEntries(from: parameters!)
        }
        
        //把json放入request请求的参数
        //    r_param["data"] = paramData.description
        
        //把请求参数转成JSON
        let jsonData = JSON(paramData)
        
        //把json放入request请求的参数
        r_param["data"] = jsonData.description
        
        print("url:\(url)\nparam:\(JSON.init(r_param).description)")
        
        return Alamofire.request(url, method: method, parameters: r_param, encoding: URLEncoding.default, headers: ["Content-type":"application/x-www-form-urlencoded"])
        
    }
    
    func myPostRequest2(_ url:String, _ parameters: [String: Any]? = nil , method: HTTPMethod = HTTPMethod.post) -> DataRequest {
        
        let paramData = NSMutableDictionary()
        
        //合并默认参数和用户请求的参数
        if parameters != nil{
            paramData.addEntries(from: parameters!)
        }
        
        
        //把json放入request请求的参数
        //    r_param["data"] = paramData.description
        
        //把请求参数转成JSON
        let jsonData = JSON(paramData)
        
        //把json放入request请求的参数
        r_param["data"] = jsonData.description
        
        print("url:\(url)\nparam:\(JSON.init(r_param).description)")
        
        return Alamofire.request(url, method: method, parameters: r_param, encoding: URLEncoding.default, headers: ["Content-type":"application/x-www-form-urlencoded"])
        
    }
    
    
    
}
