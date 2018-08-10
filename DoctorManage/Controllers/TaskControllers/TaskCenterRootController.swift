//
//  TaskCenterRootController.swift
//  DoctorManage
//
//  Created by chenhaifeng on 2018/8/10.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit

class TaskCenterRootController: UIViewController{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var botttomLine: UIView!
    let leftTableView = UITableView()
    let rightTableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    func configUI() {
        scrollView.contentSize = CGSize(width: kScreenH*2, height: 0)
        scrollView.isScrollEnabled = false
        scrollView.addSubview(leftTableView)
        scrollView.addSubview(rightTableView)
//        leftTableView.
    }
    
    @IBAction func switchTypeAction(_ sender: UIButton) {
        botttomLine.center = CGPoint(x: sender.center.x, y: botttomLine.center.y)
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
