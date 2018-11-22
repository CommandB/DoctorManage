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

                    if let officeList = UserDefaults.AppConfig.any(forKey: .officeList) as? [[String:String]] {
                        print(officeList)
                    }
                    
                    guard let description = UserDefaults.AppConfig.string(forKey: .officeList) else { return }
                    let json2 = JSON(description) 
                    print(json2.arrayValue)
//                    self.dataSource = json["data"].arrayValue
//                    self.tableview.reloadData()
                }else{
                    print("error")
                }
            }
        }
        
        
        
    }
}
