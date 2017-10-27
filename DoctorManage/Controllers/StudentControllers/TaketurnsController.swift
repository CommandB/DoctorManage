//
//  TaketurnsController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/8.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class TaketurnsController: BaseViewController {
    var dataSource:[NSDictionary] = []
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib1 = UINib(nibName: "TakeTurnsCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "TakeTurnsCell")
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        getData()
    }
    
    func getData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params = ["personid":infoDic["personid"].stringValue,"token":UserInfo.instance().token]
        NetworkTool.sharedInstance.requestQueryStudentOutlineByTeacherURL(params: params as! [String : String], success: { (response) in
            MBProgressHUD.hide(for:  self.view, animated: true)
            if let data = response["data"],response["data"]?.count != 0{
                self.dataSource = data as! [NSDictionary]
                self.tableView.reloadData()
            }
            else if response["data"]?.count == 0{
            }
        }) { (error) in
            MBProgressHUD.hide(for:  self.view, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TakeTurnsCell", for: indexPath) as! TakeTurnsCell
        cell.titleLabel.text = dataSource[indexPath.section].stringValue(forKey: "outlinename")
        cell.detailLabel.text = "达成数例"
        cell.titleNum.text = dataSource[indexPath.section].stringValue(forKey: "requirednum")
        cell.detailNum.text = dataSource[indexPath.section].stringValue(forKey: "completenum")
        cell.ratioNum.text = String(Float(cell.detailNum.text!)!/Float(cell.titleNum.text!)!*100)+"%"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! TakeTurnsCell
        
        let masterSkillVC = MasterSkillController()
        masterSkillVC.receiveDataList = dataSource[indexPath.section].value(forKey: "my_data_list") as! [NSDictionary]
        masterSkillVC.title = dataSource[indexPath.section].stringValue(forKey: "outlinename")
        masterSkillVC.completenum = cell.detailNum.text!
        masterSkillVC.titleNum = cell.titleNum.text!
        masterSkillVC.ratioNum = cell.ratioNum.text!
        let nav = UINavigationController(rootViewController: masterSkillVC)
        self.present(nav, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        return 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
