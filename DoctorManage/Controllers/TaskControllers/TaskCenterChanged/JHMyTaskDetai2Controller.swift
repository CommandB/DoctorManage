//
//  JHMyTaskDetaiController.swift
//  DoctorManage
//
//  Created by chenhaifeng on 2018/8/10.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
class JHMyTaskDetai2Controller: UIViewController {
    var headDataJson = JSON.init("")
    var teachingmaterialJson = JSON.init("")
    let c : CircleDataView = CircleDataView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let barView = view.viewWithTag(11111)
        let titleView = view.viewWithTag(22222)
        setNavigationBarColor(views: [barView,titleView], titleIndex: 1,titleText: "任务明细")
        var lbl = view.viewWithTag(80001)
        self.c.frame = (lbl?.frame)!
        //        self.c.backgroundColor = UIColor.white
        //        self.c.progress = 2/2
        //
        //        self.view.addSubview(self.c)
        
        lbl = view.viewWithTag(80002)
        lbl?.layer.cornerRadius = 4
        lbl?.clipsToBounds = true
        lbl = view.viewWithTag(80004)
        lbl?.layer.cornerRadius = 4
        lbl?.clipsToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        var lbl = view.viewWithTag(10001) as! UILabel
        lbl.text = headDataJson["title"].stringValue
        lbl = view.viewWithTag(10002) as! UILabel
        lbl.text = headDataJson["student_state_show"].stringValue
        lbl = view.viewWithTag(20001) as! UILabel
        lbl.text = headDataJson["starttime_show"].stringValue
        lbl = view.viewWithTag(30001) as! UILabel
        lbl.text = headDataJson["endtime_show"].stringValue
        lbl = view.viewWithTag(40001) as! UILabel
        lbl.text = headDataJson["credit"].stringValue
        lbl = view.viewWithTag(50001) as! UILabel
        lbl.text = headDataJson["creater"].stringValue
        lbl = view.viewWithTag(60001) as! UILabel
        lbl.text = headDataJson["note"].stringValue
        lbl = view.viewWithTag(70001) as! UILabel
        if headDataJson["isneedsign"].stringValue == "0"{
            lbl.text = "否"
        }else{
            lbl.text = "是"
        }
        lbl = view.viewWithTag(90001) as! UILabel
        lbl.text = headDataJson["tasktypeshow"].stringValue
        lbl = view.viewWithTag(100001) as! UILabel
        lbl.text = headDataJson["addressname"].stringValue
        
        let lateImageView = view.viewWithTag(101010) as! UIImageView
        var lateImage = UIImage()
        do{
            if let imageurl = URL(string: headDataJson["siginurl"].stringValue) {
                try lateImage = UIImage(data: Data.init(contentsOf: imageurl))!
            }
        }catch{
            
        }
        lateImageView.image = lateImage
        
        getTaskDetail()
    }
    
    //获取已完成的任务
    func getTaskDetail(){

        let url = "http://"+Ip_port2+"doctor_train/rest/task/queryDetail.do"
        myPostRequest(url,["taskid":headDataJson["taskid"].stringValue , "task_type":headDataJson["task_type"].stringValue,"token":UserInfo.instance().token]).responseJSON(completionHandler: {resp in
            
            switch resp.result{
            case .success(let responseJson):
                
                let json = JSON(responseJson)
                if json["code"].stringValue == "1"{
                    let sc = json["student_count"]
                    
                    let num1 = sc["uncomplete_count"].intValue
                    let num2 = sc["complete_count"].intValue
                    
                    var lbl = self.view.viewWithTag(80006) as! UILabel
                    lbl.text = "\(num1)"
                    
                    lbl = self.view.viewWithTag(80003) as! UILabel
                    lbl.text = "\(num2 / (num1 + num2) * 100)% 已完成"
                    
                    lbl = self.view.viewWithTag(80005) as! UILabel
                    lbl.text = "\(num1 / (num1 + num2) * 100)% 未完成"
                    
                    self.c.backgroundColor = UIColor.white
                    self.c.progress = CGFloat(num1 / (num1 + num2))
                    self.view.addSubview(self.c)
                    
                    
                }else{
                    myAlert(self, message: "请求未完成任务列表失败!")
                }
                
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    @IBAction func btn_back_inside(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    ///设置标题的渐变背景色
    func setNavigationBarColor(views : [UIView?] , titleIndex : Int , titleText : String){
        
        for v in views {
            if v != nil{
                let navigationBarColor = CAGradientLayer()
                navigationBarColor.startPoint = CGPoint.init(x: 0.0, y: 0.5)
                navigationBarColor.endPoint = CGPoint.init(x: 1.0, y: 0.5)
                navigationBarColor.colors = [UIColor.init(hex: "74c0e0").cgColor,UIColor.init(hex: "407bd8").cgColor]
                v?.layer.addSublayer(navigationBarColor)
                navigationBarColor.frame = (v?.bounds)!
            }
        }
        let titleView = views[titleIndex] as! UILabel
        titleView.text = ""
        
        let title = UILabel.init()
        title.frame = titleView.bounds
        //        title.frame = (titleView?.frame)!
        title.textColor = UIColor.white
        title.backgroundColor = UIColor.clear
        title.text = titleText
        title.textAlignment = NSTextAlignment.center
        title.font = UIFont.init(name: "System", size: 16)
        titleView.addSubview(title)
        
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
