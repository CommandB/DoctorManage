//
//  ReportViewController.swift
//  DoctorManage
//
//  Created by chenhaifeng  on 2017/7/18.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class ReportViewController: UITableViewController,ApplyTaskCellDelegate {
    var dataSource = [JSON]()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        let nib = UINib.init(nibName: "ApplyTaskCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "ApplyTaskCell")
        self.tableView.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
        self.tableView.mj_header.beginRefreshing()
    }

    func requestReportData(pageindex:Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlString = "http://"+Ip_port2+"doctor_train/rest/taskApply/GetTaskStudentApply.do"
        NetworkTool.sharedInstance.myPostRequest(urlString,["token":UserInfo.instance().token!,"pageindex":String(pageindex*10),"pagesize": "10","state":"0"], method: HTTPMethod.post).responseJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    self.dataSource += json["data"].arrayValue
                    self.tableView.reloadData()
                }else{
                    print("error")
                }
            }
        }
    }
    
    func refreshAction() {
        dataSource.removeAll()
        index = 0
        self.tableView.mj_footer.resetNoMoreData()
        requestReportData(pageindex: index)
    }
    
    func loadMoreAction() {
        index = index + 1
        requestReportData(pageindex: index)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApplyTaskCell", for: indexPath) as! ApplyTaskCell
        cell.titleLabel.text = dataSource[indexPath.section]["typename"].stringValue
        cell.timeLabel.text = dataSource[indexPath.section]["finshtime"].stringValue
        cell.illLabel.text = dataSource[indexPath.section]["caseid"].stringValue
        cell.contentLabel.text = dataSource[indexPath.section]["traincontent"].stringValue

        cell.delegate = self
        cell.setObject(aObj: dataSource[indexPath.section]["imglist"].arrayValue)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskApplyAlert = UIAlertController.init(title: "申报任务审批", message: nil, preferredStyle: .actionSheet)
        let sureAction = UIAlertAction.init(title: "确认任务", style: .default, handler:{
                (alert: UIAlertAction!) -> Void in
            self.requestTaskApplyAnswer(taskapplyid: self.dataSource[indexPath.section]["taskapplyid"].stringValue, state: "1")
            })
        let rejectAction = UIAlertAction.init(title: "驳回任务", style: .destructive, handler:{
                (alert: UIAlertAction!) -> Void in
            self.requestTaskApplyAnswer(taskapplyid: self.dataSource[indexPath.section]["taskapplyid"].stringValue, state: "2")
            })
        let cancelAction = UIAlertAction.init(title: "取消操作", style: .default, handler:{
            (alert: UIAlertAction!) -> Void in
        })
            taskApplyAlert.addAction(sureAction)
            taskApplyAlert.addAction(rejectAction)
            taskApplyAlert.addAction(cancelAction)
            self.present(taskApplyAlert, animated: true, completion: nil)
    }
    
    func requestTaskApplyAnswer(taskapplyid:String,state:String) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlString = "http://"+Ip_port2+"doctor_train/rest/task/Tx_CheckStudentTaskApply.do"
        NetworkTool.sharedInstance.myPostRequest(urlString,["token":UserInfo.instance().token!,"taskapplyid":taskapplyid,"state":state], method: HTTPMethod.post).responseJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    if state == "1"{
                        self.showSuccessAlert(message: "确认成功")
                        self.tableView.mj_header.beginRefreshing()
                    }else{
                        self.showSuccessAlert(message: "任务已驳回")
                    }
                    self.tableView.reloadData()
                }else{
                    print("error")
                }
            }
        }
    }

    func showSuccessAlert(message:String) {
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 2.0)
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func editTextDoneTapped(imageArr: [String],index:Int){
        FullScreenImageViewer.show(with: imageArr, at: index)
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imagelist = dataSource[indexPath.section]["imglist"].arrayValue
        let contentLabelheight = dataSource[indexPath.section]["traincontent"].stringValue.heightWithConstrainedWidth(width: self.view.frame.size.width-20, font: UIFont.systemFont(ofSize: 14))+20
        if imagelist.count<=0 {
            return 60+contentLabelheight
        }else if imagelist.count<=3{
            return 120+contentLabelheight
        }else{
            return 190+contentLabelheight
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
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
