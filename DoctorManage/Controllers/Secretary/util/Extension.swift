//
//  Extension.swift
//  DoctorManage
//
//  Created by 黄玮晟 on 2018/7/31.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import Alamofire
import UIKit
import SwiftyJSON

//var g_userOffice = [JSON]()

///跳转view
func myPresentView(_ controller:UIViewController, viewName:String , completion: (() -> Void)? = nil ){
    let vc=getViewToStoryboard(viewName)
    //跳转
    controller.present(vc, animated: true, completion: nil)
    
}

func getViewToStoryboard(_ viewName:String) -> UIViewController{
    //获取Main.Storyboard对象
    let sb=UIStoryboard(name: "Main", bundle: nil)
    //从storyboard中获取view
    return sb.instantiateViewController(withIdentifier: viewName)
    
}

///系统消息提示
func myAlert(_ viewController:UIViewController, title:String = "系统提示", message:String, btnTitle:String = "好的", handler:((UIAlertAction) -> Void)? = nil){
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: handler))
    viewController.present(alert, animated: true, completion: nil)
    
}

//post方式提交数据
func myPostRequest(_ url:String, _ parameters: [String: Any]? = nil , method: HTTPMethod = HTTPMethod.post , timeoutInterval : TimeInterval = 60) -> DataRequest {
    
    var requestParam = [String:Any]()
    let paramData = NSMutableDictionary(dictionary:["token":UserInfo.instance().token!])
    
    //合并默认参数和用户请求的参数
    if parameters != nil{
        paramData.addEntries(from: parameters!)
    }
    
    //把请求参数转成JSON
    let jsonData = JSON(paramData)
    
    //把json放入request请求的参数
    requestParam["data"] = jsonData.description
    //添加必要参数
    requestParam["myshop_forapp_key"] = 987654321
    
        print("url:\(url)\nparam:\(JSON.init(requestParam))")
    
    
    //设置请求超时时间
    let sessionManager = Alamofire.SessionManager.default
    sessionManager.session.configuration.timeoutIntervalForRequest = timeoutInterval
    
    return sessionManager.request(url, method: method, parameters: requestParam, encoding: URLEncoding.default, headers: ["Content-type":"application/x-www-form-urlencoded"])
}

///根据lbl的lineNumbner计算lbl的高度
func getHeightForLabel(lbl : UILabel) -> CGFloat{
    
    return CGFloat(lbl.numberOfLines * 20)
}

extension UIButton {
    
    @objc func set(image anImage: UIImage?, title: String,
                   titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title, for: state)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIViewContentMode,
                                             spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(attributes: [NSFontAttributeName: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
                                       left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
                                       right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}
