//
//  QuestionListController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/16.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
class QuestionListController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var listData:[JSON] = []
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "考题列表"
        tableview.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "tableviewCell")
//        let nib1 = UINib(nibName: "SubScoreCell", bundle: nil)
//        tableview.register(nib1, forCellReuseIdentifier: "SubScoreCell")
        self.tableview.tableFooterView = UIView()
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(backAction))
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewCell", for: indexPath)
        cell.textLabel?.text = listData[indexPath.row]["indexname"].stringValue+listData[indexPath.row]["title"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
    }
    func backAction(_ sender: Any) {
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
