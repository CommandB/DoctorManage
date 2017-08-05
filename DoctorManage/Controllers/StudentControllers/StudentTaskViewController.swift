//
//  StudentTaskViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/8.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class StudentTaskViewController: BaseViewController {
    var dataSource:[NSDictionary] = []
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib1 = UINib(nibName: "StudentTaskCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "StudentTaskCell")
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
        self.tableView.mj_header.beginRefreshing()
//        getData(pageindex: "0")
    }
    func getData(pageindex:Int) {
        var params = ["pageindex":String(pageindex*10),"pagesize": "10","token":UserInfo.instance().token,"fromteacher":"1"]
        if studentType == .SingleType{
            params = ["personid":String(infoDic["personid"] as! Int),"pageindex":String(pageindex*10),"pagesize": "10","token":UserInfo.instance().token,"fromteacher":"1"]
            if infoDic.count == 0 {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                return
            }
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkTool.sharedInstance.requestQueryStudentTaskURL(params: params as! [String : String], success: { (response) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            MBProgressHUD.hide(for:  self.view, animated: true)
            if let data = response["data"],response["data"]?.count != 0{
                for i in 1...(data as! [NSDictionary]).count {
                    self.dataSource.append((data as! [NSDictionary])[i-1])
                }
                self.tableView.reloadData()
            }
            else if response["data"]?.count == 0{
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            MBProgressHUD.hide(for:  self.view, animated: true)
        }
    }
    
    func refreshAction() {
        dataSource.removeAll()
        index = 0
        self.tableView.mj_footer.resetNoMoreData()
        getData(pageindex: index)
    }
    
    func loadMoreAction() {
        index = index + 1
        getData(pageindex: index)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTaskCell", for: indexPath) as! StudentTaskCell
        cell.titleLabel.text = dataSource[indexPath.section].stringValue(forKey: "title")
        cell.countDownLabel.text = "倒计时20:35"
        if Int(dataSource[indexPath.section].stringValue(forKey: "left_hour"))! < 0 {
            cell.countDownLabel.text = "0"
        }else{
            cell.countDownLabel.text = dataSource[indexPath.section].stringValue(forKey: "left_hour")
        }
        cell.beginTimeLabel.text = dataSource[indexPath.section].stringValue(forKey: "starttime_show")
        cell.timeLabel.isHidden = true
        cell.addressLabel.text = dataSource[indexPath.section].stringValue(forKey: "addressname")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        return 5
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
