//
//  WishlistViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/8.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class WishlistViewController: BaseViewController,WishlistCellDelegate {
    var arrangeBtn = UIButton()
    var dataSource:[JSON] = [JSON]()
    var arrangeDataDic = [String:JSON]()
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib1 = UINib(nibName: "WishlistCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "WishlistCell")
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
//        getData(pageindex: "0")
    }

    func getData(pageindex:Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        var params = ["pageindex":String(pageindex*10),"pagesize": "10","token":UserInfo.instance().token,"fromteacher":"1"]
        if studentType == .SingleType{
            params = ["personid":String(infoDic["personid"] as! Int),"pageindex":String(pageindex*10),"pagesize": "10","token":UserInfo.instance().token,"fromteacher":"1"]
            if infoDic.count == 0 {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                return
            }
        }
        let urlString = "http://"+Ip_port2+kQueryStudentWishListURL
        NetworkTool.sharedInstance.myPostRequest(urlString,params, method: HTTPMethod.post).responseJSON { (response) in
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
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
                    if json["data"].arrayValue.count == 0{
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                }else{
                    print("error")
                }
            }
        }
//        NetworkTool.sharedInstance.requestQueryStudentWishListURL(params: params as! [String : String], success: { (response) in
//            self.tableView.mj_header.endRefreshing()
//            self.tableView.mj_footer.endRefreshing()
//            MBProgressHUD.hide(for:  self.view, animated: true)
//            if let data = response["data"],response["data"]?.count != 0{
//                for i in 1...(data as! [NSDictionary]).count {
//                    self.dataSource.append((data as! [NSDictionary])[i-1])
//                }
//                self.tableView.reloadData()
//            }
//            else if response["data"]?.count == 0{
//                self.tableView.mj_footer.endRefreshingWithNoMoreData()
//            }
//        }) { (error) in
//            self.tableView.mj_header.endRefreshing()
//            self.tableView.mj_footer.endRefreshing()
//            MBProgressHUD.hide(for:  self.view, animated: true)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.mj_header.beginRefreshing()
    }
    func refreshAction() {
        dataSource.removeAll()
        arrangeDataDic.removeAll()
        self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishlistCell", for: indexPath) as! WishlistCell
        cell.titleLabel.text = dataSource[indexPath.section]["typename"].stringValue
        cell.contentLabel.text = dataSource[indexPath.section]["wishcontent"].stringValue
        cell.timeLabel.text = dataSource[indexPath.section]["createtimeshow"].stringValue
        cell.nameLabel.text = dataSource[indexPath.section]["personname"].stringValue
        
//        if cell.checkBtn.isSelected {
//            cell.checkBtn.setBackgroundImage(UIImage.init(named: "勾选"), for: .normal)
//        }else{
//            cell.checkBtn.setBackgroundImage(UIImage.init(named: "未勾选"), for: .normal)
//        }
 
        if arrangeDataDic.keys.contains(String(indexPath.section)) {
            cell.checkBtn.setBackgroundImage(UIImage.init(named: "勾选"), for: .normal)
        }else{
            cell.checkBtn.setBackgroundImage(UIImage.init(named: "未勾选"), for: .normal)
        }
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! WishlistCell
        if cell.checkBtn.isSelected {
            cell.checkBtn.setBackgroundImage(UIImage.init(named: "未勾选"), for: .normal)
            cell.checkBtn.isSelected = false
//            let index = arrangeDataArr.index(of: dataSource[indexPath.section])
//            arrangeDataArr.remove(at: index!)
            arrangeDataDic.removeValue(forKey: String(indexPath.section))
        }else{
            cell.checkBtn.setBackgroundImage(UIImage.init(named: "勾选"), for: .normal)
            cell.checkBtn.isSelected = true
//            arrangeDataArr.append(dataSource[indexPath.section])
            arrangeDataDic[String(indexPath.section)] = dataSource[indexPath.section]
        }
    }
    
    func addWishList(_ sender: UIButton){
        let cell = sender.superview?.superview as! WishlistCell
        let indexPath = tableView.indexPath(for: cell)!
        if cell.checkBtn.isSelected {
            cell.checkBtn.setBackgroundImage(UIImage.init(named: "未勾选"), for: .normal)
            cell.checkBtn.isSelected = false
            //            let index = arrangeDataArr.index(of: dataSource[indexPath.section])
            //            arrangeDataArr.remove(at: index!)
            arrangeDataDic.removeValue(forKey: String(indexPath.section))
        }else{
            cell.checkBtn.setBackgroundImage(UIImage.init(named: "勾选"), for: .normal)
            cell.checkBtn.isSelected = true
            //            arrangeDataArr.append(dataSource[indexPath.section])
            arrangeDataDic[String(indexPath.section)] = dataSource[indexPath.section]
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        return 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let superView = self.parent?.view
        superView?.addSubview(arrangeBtn)
        arrangeBtn.translatesAutoresizingMaskIntoConstraints = false
        superView?.addConstraint(NSLayoutConstraint.init(item: arrangeBtn, attribute: .trailing, relatedBy: .equal, toItem: superView, attribute: .trailing, multiplier: 1, constant: -10))
        superView?.addConstraint(NSLayoutConstraint.init(item: arrangeBtn, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1, constant: -50))
        arrangeBtn.setBackgroundImage(UIImage.init(named: "安排"), for: .normal)
        arrangeBtn.addTarget(self, action: #selector(arrangeBtnTapped), for: .touchUpInside)
    }
    
    func arrangeBtnTapped() {
        if arrangeDataDic.keys.count == 0 {
            MBProgressHUD.showError("先选择心愿单", to: self.view)
            return
        }
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let taskCenterVC = storyboard.instantiateViewController(withIdentifier: "arrangeTaskView") as! ArrangeTaskController
        var arrangeDataArr = [JSON]()
        for key in arrangeDataDic.keys {
            arrangeDataArr.append(arrangeDataDic[key]!)
        }
        taskCenterVC.receiveData = JSON.init(arrangeDataArr)
        let nav = UINavigationController(rootViewController: taskCenterVC)
        self.present(nav, animated: true, completion: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        arrangeBtn.removeFromSuperview()
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
