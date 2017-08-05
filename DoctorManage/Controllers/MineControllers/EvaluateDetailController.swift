//
//  EvaluateDetailController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/7/3.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class EvaluateDetailController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(backAction))
        self.title = "评价明细"
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.init(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        let nib1 = UINib.init(nibName: "EvaluateHeadCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "EvaluateHeadCell")
        let nib2 = UINib.init(nibName: "EvaluateContentCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "EvaluateContentCell")
        requestMyEvaluateDetailData()
    }

    func requestMyEvaluateDetailData() {
        let urlString = "http://"+Ip_port2+kMyEvalueDetailURL
        NetworkTool.sharedInstance.myPostRequest(urlString,["token":UserInfo.instance().token!,"pageindex":"0","pagesize": "1000"], method: HTTPMethod.post).responseJSON { (response) in
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
//                    self.onlineQuestionData = json["data"].arrayValue
                    self.tableView.reloadData()
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

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateHeadCell") as! EvaluateHeadCell
                cell.favRatio.text = "好评70%"
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateContentCell") as! EvaluateContentCell
                switch indexPath.row {
                case 1:
                    cell.titleLabel.text = "教学目标"
                case 2:
                    cell.titleLabel.text = "内容编写"
                case 3:
                    cell.titleLabel.text = "教材参考"
                default:
                    break
                }
                cell.contentLabel.text = "突出重点"
                cell.getScore.text = "得分"+"80"+"分"
                cell.favRatio.text = "好评"+"80%"
                if indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1 {
                 cell.bottomLine.isHidden = true
                }else{
                    cell.bottomLine.isHidden = false
                }
                return cell
            }
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateHeadCell") as! EvaluateHeadCell
                cell.favRatio.text = "好评80%"
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateContentCell") as! EvaluateContentCell
                switch indexPath.row {
                case 1:
                    cell.titleLabel.text = "概念阐述"
                case 2:
                    cell.titleLabel.text = "重点难点"
                case 3:
                    cell.titleLabel.text = "教材参考"
                default:
                    break
                }
                cell.contentLabel.text = "突出重点"
                cell.getScore.text = "得分"+"80"+"分"
                cell.favRatio.text = "好评"+"80%"
                if indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1 {
                    cell.bottomLine.isHidden = true
                }else{
                    cell.bottomLine.isHidden = false
                }
                return cell
            }
        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
