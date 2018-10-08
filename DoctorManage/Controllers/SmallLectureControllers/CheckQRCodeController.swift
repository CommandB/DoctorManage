//
//  CheckQRCodeController.swift
//  DoctorManage
//
//  Created by chenhaifeng on 2018/10/8.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CheckQRCodeController: JHBaseViewController {
    var taskid = ""
    var detailDic = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "任务明细"
        setNavBackItem(true)
        configUI()
        requestQRCode()
    }

    func configUI() {
    
    }
    
    func requestQRCode() {
        let urlString = "http://"+Ip_port2+"doctor_train/rest/public/GenerateQRCode.do"
        let params = ["token":UserInfo.instance().token,"type":"pctask","taskid":taskid] as! [String:String]
        
        Alamofire.request(urlString, method: .post, parameters: params).responseJSON { (response) in
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
//                    self.dataSource = json["data"].arrayValue
//                    self.tableview.reloadData()
                }else{
                    print("error")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
