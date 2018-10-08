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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var codeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "任务明细"
        setNavBackItem(true)
        configUI()
        requestQRCode()
    }

    func configUI() {
        titleLabel.text = detailDic["title"] as? String
        beginTimeLabel.text = detailDic["starttime"] as? String
        endTimeLabel.text = detailDic["endtime"] as? String
        addressLabel.text = detailDic["addressname"] as? String

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
                if json["code"].stringValue == "1" {
                    if let url = URL.init(string: json["qrcode"].stringValue) {
                        self.codeImageView.sd_setImage(with: url, placeholderImage: nil)
                    }
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
