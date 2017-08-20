//
//  AnswerListController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/22.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
class AnswerListController: UITableViewController {
    var questionListArr:[JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "答疑列表"
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(backAction))
        setSubviews()
    }

    func setSubviews() {
        let nib1 = UINib(nibName: "AnswerListCell", bundle: nil)
        self.tableView.register(nib1, forCellReuseIdentifier: "AnswerListCell")
        tableView.separatorStyle = .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionListArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerListCell", for: indexPath) as! AnswerListCell
        cell.titleLabel.text = String(indexPath.row+1)+". "+questionListArr[indexPath.row]["title"].stringValue
        cell.contentLabel.text = questionListArr[indexPath.row]["content"].stringValue
        cell.nameLabel.text = questionListArr[indexPath.row]["personname"].stringValue
        cell.timeLabel.text = questionListArr[indexPath.row]["createtime"].stringValue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let answerDetailVC = storyboard.instantiateViewController(withIdentifier: "answerDetailView") as! AnswerDetailController
        answerDetailVC.dataSource = questionListArr[indexPath.row]
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(answerDetailVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return questionListArr[indexPath.row]["content"].stringValue.heightWithConstrainedWidth(width: self.view.frame.size.width-30, font: UIFont.systemFont(ofSize: 14))+70
    }

    func backAction(_ sender: Any) {
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
