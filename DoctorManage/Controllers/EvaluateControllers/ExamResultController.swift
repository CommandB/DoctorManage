//
//  ExamResultController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/17.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
class ExamResultController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var passImageView: UIImageView!
    @IBOutlet weak var getScore: UILabel!
    var dataSource = JSON([:])
    var listData:[JSON] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "考试结果"
        self.navigationItem.hidesBackButton = true
        tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "basecell")
        tableview.tableFooterView = UIView()
        totalScoreLabel.layer.cornerRadius = totalScoreLabel.frame.size.height/2
        totalScoreLabel.layer.masksToBounds = true
        reloadHeadView()
    }

    func reloadHeadView() {
        totalScoreLabel.text = "总分"+dataSource["exercisesscore"].stringValue+"分"
        getScore.text = "总得分"+dataSource["score"].stringValue+"分"
        if dataSource["ispass"].stringValue == "1" {
            passImageView.image = UIImage.init(named: "通过")
        }else{
            passImageView.image = UIImage.init(named: "未通过")
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basecell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        cell.textLabel?.textColor = UIColor.init(red: 59/255.0, green: 69/255.0, blue: 79/255.0, alpha: 1.0)
        if indexPath.row == 0 {
            cell.textLabel?.text = "答题明细"
        }else{
            cell.textLabel?.text = listData[indexPath.row-1]["indexname"].stringValue+listData[indexPath.row-1]["title"].stringValue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    @IBAction func backToExamCenter(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
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
