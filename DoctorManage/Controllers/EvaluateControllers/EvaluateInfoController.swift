//
//  EvaluateInfoController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/22.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class EvaluateInfoController: UIViewController,UITableViewDelegate,UITableViewDataSource,EvaluateSecondCellDelegate {
    var tableView = UITableView()
    var headInfo  = JSON([:])
    var dataSource:[NSDictionary] = []
    var storageData = JSON([:])
    var evaluateStarData = JSON([:])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评价"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "topBack.png"), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(dismissAction))
        setSubviews()
        requestEvaluateStarData()
    }
    
    func requestEvaluateStarData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let urlString = "http://"+Ip_port2+kQueryTaskStarURL
        let params = ["token":UserInfo.instance().token,"evaluationid":headInfo["evaluationid"].stringValue]
        NetworkTool.sharedInstance.myPostRequest(urlString,params, method: HTTPMethod.post).responseJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    self.evaluateStarData = json["data"]
                    for i in 0...self.evaluateStarData.count-1 {
                        self.evaluateStarData[i]["get_value"].stringValue = "5"
                    }
                    self.tableView.reloadData()
                }else{
                    print("error")
                }
            }
        }
    }
    
    func setSubviews() {
        tableView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-128)
        tableView.delegate = self
        tableView.dataSource = self
        let nib1 = UINib(nibName: "EvaluateBaseCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "EvaluateBaseCell")
        let nib2 = UINib(nibName: "EvaluateSecondCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "EvaluateSecondCell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        let submitBtn = UIButton()
        self.view.addSubview(submitBtn)
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint.init(item: submitBtn, attribute: NSLayoutAttribute.bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: submitBtn, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: submitBtn, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0))
        submitBtn.setBackgroundImage(UIImage.init(named: "提交评价@2x"), for: .normal)
        submitBtn.setTitle("提交评价", for: .normal)
        submitBtn.addTarget(self, action: #selector(commitAction(sender:)), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.evaluateStarData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateBaseCell", for: indexPath) as! EvaluateBaseCell
            cell.titleLabel.text = headInfo["title"].stringValue
            cell.typeLabel.text = headInfo["evaluatetypename"].stringValue
            cell.timeLabel.text = headInfo["createtime"].stringValue
            cell.personLabel.text = headInfo["bepersonname"].stringValue
            cell.accessView?.isHidden = true
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateSecondCell", for: indexPath) as! EvaluateSecondCell
            cell.titleLabel.text = evaluateStarData[indexPath.row]["itemtitle"].stringValue
//            cell.setYellowStarNum(num: 0)
            let yellowStarNum = evaluateStarData[indexPath.row]["get_value"].intValue
            cell.setYellowStarNum(num: yellowStarNum)
            cell.tag = 500+indexPath.row
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func commitAction(sender:UIButton){
        for itemInfo in evaluateStarData.arrayValue {
            if itemInfo["get_value"].intValue == 0 {
                MBProgressHUD.showError("请查看遗漏评价", to: self.navigationController?.view)
                return;
            }
        }
        
        sender.isEnabled = false
        MBProgressHUD.showMessage("提交中", to: self.view)
        let urlString = "http://"+Ip_port2+kCommitEvaluationResultURL
        var params = JSON(["items":evaluateStarData]).dictionaryObject
        params?["taskid"] = headInfo["taskid"].stringValue
        params?["token"] = UserInfo.instance().token
        
        NetworkTool.sharedInstance.myPostRequest2(urlString,params , method: HTTPMethod.post).responseJSON { (response) in
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
            sender.isEnabled = true
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    BRAlertView.show(message: "评价成功", target: self, duration: 2.0)
                }else{
                    MBProgressHUD.showError("评价失败", to: self.view)
                    print("error")
                }
            }
        }
        
    }
    
    //MARK:EvaluateSecondCellDelegate
    func updateModelDataDelegate(yellowStarNum: Int,cell:EvaluateSecondCell){
        evaluateStarData[cell.tag-500]["get_value"].stringValue = String(yellowStarNum)
        self.tableView.reloadData()
    }
    
    func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
