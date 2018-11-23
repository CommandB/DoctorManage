//
//  HisEvaluateDetailController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/7/12.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class HisEvaluateDetailController: UITableViewController {
    var headInfo:JSON = JSON([:])
    var starListArr = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评价详情"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "topBack.png"), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(backAction))
        setSubviews()
        requestHisEvaluateDetailData()
    }

    func requestHisEvaluateDetailData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlString = "http://"+Ip_port2+"doctor_train/rest/evaluation/queryHistoryResultInfo.do"
        NetworkTool.sharedInstance.myPostRequest(urlString,["token":UserInfo.instance().token!,"taskid":headInfo["taskid"].stringValue,"evaluationid": headInfo["evaluationid"].stringValue], method: HTTPMethod.post).responseJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    self.starListArr = json["data"].arrayValue
                    self.tableView.reloadData()
                }else{
                    print("error")
                }
            }
        }
    }
    func setSubviews() {
        let nib1 = UINib(nibName: "HistoryEvaluateCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "HistoryEvaluateCell")
        let nib2 = UINib(nibName: "EvaluateStarCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "EvaluateStarCell")
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = UIColor.init(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
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
        if section == 0 {
            return 1
        }
        return starListArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryEvaluateCell", for: indexPath) as! HistoryEvaluateCell
            cell.titleLabel.text = headInfo["evaluationtitle"].stringValue
            cell.personLabel.text = headInfo["evalutedpersonname"].stringValue
            cell.scoreLabel.text = headInfo["evaluarate"].stringValue
            cell.timeLabel.text = headInfo["evaluationtime"].string
            cell.selectionStyle = .none
            cell.enterIconView.isHidden = true
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateStarCell", for: indexPath) as! EvaluateStarCell
            cell.titleLabel.text = starListArr[indexPath.row]["itemtitle"].stringValue
            let yellowStarNum = starListArr[indexPath.row]["numbervalue"].intValue
            cell.setYellowStarNum(num: yellowStarNum , allStars: starListArr[indexPath.row]["starsvalue"].intValue)
            cell.selectionStyle = .none
            return cell
        }
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
