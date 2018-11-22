//
//  SubValuateController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/9.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SubValuateController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableview = UITableView()
    var headInfo:NSDictionary!
    var dataSource:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        self.tableview = UITableView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.bounds.size.height-64))
        self.view.addSubview(tableview)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        let nib = UINib(nibName: "BaseTableViewCell", bundle: nil)
        self.tableview.register(nib, forCellReuseIdentifier: "BaseCell")
        let nibs = UINib(nibName: "EvaluateCell", bundle: nil)
        self.tableview.register(nibs, forCellReuseIdentifier: "EvaluateCell")
        
//        self.tableview.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        self.tableview.separatorStyle = .none
        self.tableview.tableFooterView = UIView()
        requestEvaluateData()
    }

    func requestEvaluateData() {
        let urlString = "http://"+Ip_port2+kQueryTaskevaluationresultinfoRateURL
        guard let taskid = headInfo["taskid"] else { return }
        let params = ["token":UserInfo.instance().token,"taskid":taskid] as! [String:String]
        
        Alamofire.request(urlString, method: .post, parameters: params).responseJSON { (response) in
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    self.dataSource = json["data"].arrayValue
                    self.tableview.reloadData()
                }else{
                    print("error")
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableview.dequeueReusableCell(withIdentifier: "BaseCell", for: indexPath) as! BaseTableViewCell
            cell.titleLabel.text = headInfo.stringValue(forKey: "title")
//            cell.timeLabel.text = "(今天)"
            cell.timeLabel.isHidden = true
            cell.retainTimeLabel.text = headInfo.stringValue(forKey: "overhour")
            cell.beginTimeLabel.text = headInfo.stringValue(forKey: "starttime_show")
            cell.addressLabel.text = headInfo.stringValue(forKey: "addressname")
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateCell", for: indexPath) as! EvaluateCell
            cell.titleLabel.text = dataSource[indexPath.row]["itemtitle"].stringValue
            let ratio = dataSource[indexPath.row]["evaluation_rate"].stringValue
            cell.goodRatio.text = String(Float(ratio)!*100)+"%"
            cell.setYellowStarNum(num: Int(Float(ratio)!*5))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==0 {
            return 5
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
            let lable1 = UILabel.init(frame: CGRect(x: 20, y: 0, width: 100, height: 44))
            lable1.text = "课程评价"
            lable1.font = UIFont.systemFont(ofSize: 14.0)
            lable1.textColor = UIColor.gray
            let lable2 = UILabel.init(frame: CGRect(x: self.view.frame.width - 120, y: 0, width: 100, height: 44))
            lable2.textColor = UIColor.gray
            lable2.font = UIFont.systemFont(ofSize: 14.0)
            lable2.text = "好评率"
            lable2.textAlignment = NSTextAlignment.right
            
            let lable3 = UILabel.init(frame: CGRect(x: 10, y: 43, width: self.view.frame.width - 20, height: 1.0))
            lable3.backgroundColor = UIColor.init(red: 233 / 255.0, green: 235 / 255.0, blue: 243 / 255.0, alpha: 1.0)
            
            view.addSubview(lable2)
            view.addSubview(lable1)
            view.addSubview(lable3)
            return view
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(TaskDetailController(), animated: true)
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
