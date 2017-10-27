//
//  PersonalInfoController.swift
//  jiaoshi3
//
//  Created by chenhaifeng  on 2017/6/9.
//  Copyright © 2017年 chenhaifeng . All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PersonalInfoController: BaseViewController,CheckWorkCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib1 = UINib(nibName: "PersonalnfoCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "PersonalnfoCell")
        let nib2 = UINib(nibName: "CheckWorkCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "CheckWorkCell")
        tableView.separatorStyle = .none
        
        let tabFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 100))
        tabFooterView.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        self.tableView.tableFooterView = tabFooterView

//        tableView.estimatedRowHeight = 44.0;//推测高度，必须有，可以随便写多少
//        tableView.rowHeight = UITableViewAutomaticDimension;//iOS8之后默认就是这个值，可以省略
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalnfoCell", for: indexPath) as! PersonalnfoCell
            cell.major.text = infoDic["subjectname"].stringValue
            cell.jobNum.text = infoDic["jobnum"].stringValue
            cell.education.text = infoDic["highestdegree"].stringValue
            cell.grade.text = infoDic["grade_show"].stringValue
            cell.company.text = infoDic["hospital"].stringValue
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckWorkCell", for: indexPath) as! CheckWorkCell
            cell.attendRatio.text = String(infoDic["workrate"].floatValue*100)+"%"
            cell.absent.text = "已缺勤"+infoDic["unworkdays"].stringValue+"天"
            cell.delegate = self
            let todayisunwork = infoDic["todayisunwork"].stringValue
            if todayisunwork == "0"{
                cell.absentBtn.setTitle("该学员今日缺勤", for: .normal)
                }else{
                cell.absentBtn.setTitle("取消缺勤", for: .normal)
            }
            cell.selectionStyle = .none
            return cell
        }

    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 5
    }
    
    func requestAbsentData(title:String,sender:UIButton) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var state = "0"
        if title == "该学员今日缺勤" {
            state = "1"
        }
        let params = ["personid":infoDic["personid"].stringValue,"state": state,"myshop_forapp_key":"987654321","token":UserInfo.instance().token] as! [String:String]
        let urlString = "http://"+Ip_port2+"doctor_train/rest/task/updateStudentWorkState.do"
        print(params)
        Alamofire.request(urlString, method: .post, parameters: params).responseJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                   self.infoDic["unworkdays"] = json["unworkdays"]
//                    self.infoDic.setValue(json["unworkdays"].stringValue, forKey: "unworkdays")
                    let cell = self.tableView.cellForRow(at: IndexPath.init(item: 0, section: 1)) as! CheckWorkCell
//                    cell.attendRatio.text = String(Int(infoDic.stringValue(forKey: "workrate"))!*100)+"%"
                    cell.absent.text = "已缺勤"+(json["unworkdays"].stringValue)+"天"
                    if json["todayisunwork"].stringValue == "0"{
                        cell.absentBtn.setTitle("取消缺勤", for: .normal)
                    }else{
                        cell.absentBtn.setTitle("该学员今日缺勤", for: .normal)
                    }
                }else{
                    print("error")
                }
            }
            sender.isEnabled = true
        }
    }
    
    func absentBtnDidTapped(title: String,sender:UIButton){
        sender.isEnabled = false
        requestAbsentData(title: title, sender: sender)
    }
    
    func dismissAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
