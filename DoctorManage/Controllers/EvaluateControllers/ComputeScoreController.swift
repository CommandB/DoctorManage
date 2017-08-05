//
//  ComputeScoreController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/17.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
protocol ComputeScoreControllerDelegate: class {
    func updateCommitData()
}
class ComputeScoreController: UIViewController,UITableViewDelegate,UITableViewDataSource,DeduceScoreCellDelegate {
    @IBOutlet weak var tableview: UITableView!
    weak var delegate: ComputeScoreControllerDelegate?
    var itemData = JSON([:])
    var duduceScore = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评分"
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(backAction))
        let nib1 = UINib(nibName: "ComputeScroHeadCell", bundle: nil)
        tableview.register(nib1, forCellReuseIdentifier: "ComputeScroHeadCell")
        let nib2 = UINib(nibName: "DeduceScoreCell", bundle: nil)
        tableview.register(nib2, forCellReuseIdentifier: "DeduceScoreCell")
        tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "contentCell")
        tableview.tableFooterView = UIView()
        tableview.separatorStyle = .none
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ComputeScroHeadCell", for: indexPath) as! ComputeScroHeadCell
                cell.titleLabel.text = "考题一：非同步除颤操作"
                cell.scoreLabel.text = "总分12"
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath) 
                cell.textLabel?.text = itemData["title"].stringValue
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
                cell.textLabel?.numberOfLines = 0
                return cell
            }
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ComputeScroHeadCell", for: indexPath) as! ComputeScroHeadCell
                cell.titleLabel.text = "评分标注"
                cell.scoreLabel.text = "总分"+itemData["score"].stringValue
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DeduceScoreCell", for: indexPath) as! DeduceScoreCell
                cell.scoreruleLabel.text = itemData["scorerule"].stringValue
                cell.deducedLabel.text = "已扣"+duduceScore+"分"
                cell.delegate = self
                return cell
            }
        }
    }
    
    func deduceScoreBtnDidTapped(){
        let alertController = UIAlertController(title: "请输入扣减分值", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField:UITextField) in
            textField.placeholder = "请输入扣减分值"
            textField.keyboardType = .decimalPad
        }
        let cancelAction = UIAlertAction(title: "取消", style:.cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
//            let login = alertController.textFields![0]
//            let pwd = alertController.textFields![1]
//            print("用户名：\(login.text) 密码：\(pwd.text)")
            let str = (alertController.textFields?[0].text)!.trimmingCharacters(in: .whitespaces)
            if let deduce = Float(str){
                if deduce > self.itemData["score"].floatValue{
                    self.duduceScore = self.itemData["score"].stringValue
                }else{
                    self.duduceScore = (alertController.textFields?[0].text)!
                }
                self.itemData["getscore"].floatValue = self.itemData["score"].floatValue-Float(self.duduceScore)!
            }
            self.tableview.reloadData()
            self.delegate?.updateCommitData()
            self.updataCommitData()
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updataCommitData() {
//        for  info in BRCommitDataManage.shared.allItemQuestions.arrayValue {
//            if info["type"] == itemData["type"] && info["itemid"] == itemData["itemid"]{
//                var index = BRCommitDataManage.shared.allItemQuestions.arrayValue.index(of: info)
//                BRCommitDataManage.shared.allItemQuestions.arrayValue[index!] = itemData
////                info["getscore"] = self.itemData
//            }
//            
//        }
        
        for  info in BRCommitDataManage.shared.allItemQuestions {
            if info["type"] == itemData["type"] && info["itemid"] == itemData["itemid"]{
                let index = BRCommitDataManage.shared.allItemQuestions.index(of: info)
                BRCommitDataManage.shared.allItemQuestions[index!] = itemData
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 44
            }
            return 60
        }else{
            if indexPath.row == 0 {
                return 44
            }
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        return 15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func backAction() {
        self.navigationController?.popViewController(animated: true)
        
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
