//
//  PublishLectureController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/10.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit

class PublishLectureController: JHBaseViewController,UIScrollViewDelegate {
    var headView = PublishLectureHeadView()
    
    var scrollView = UIScrollView()
    var taskType = 1000

    var firstVC = PublicBaseInfoViewController()
    var secondVC = PublicTrainViewController()
    var thirdVC = PublicFilesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProperty()
        addSubViews()
    }

    func initProperty() {
        self.view.backgroundColor = UIColor.rgb(r: 239, g: 239, b: 239)
        self.title = "发布讲座"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancelAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .done, target: self, action: #selector(publishAction))
    }
    
    func addSubViews() {
        self.view.addSubview(headView)
        headView.mas_makeConstraints { (make) in
            make?.height.equalTo()(50)
            make?.top.offset()(0)
            make?.left.right().equalTo()(self.view)
        }
        headView.buttonClickCallBack = { (tag) in
            self.changeViewWithTag(type: tag)
        }
        
        self.view.addSubview(scrollView)
        scrollView.mas_makeConstraints { (make) in
            make?.top.equalTo()(headView.mas_bottom)
            make?.left.right().offset()(0)
            make?.bottom.offset()(0)
        }
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: kScreenW*3, height: 0)
        scrollView.delegate = self
        
        firstVC.view.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH-64-50)
        secondVC.view.frame = CGRect.init(x: kScreenW, y: 0, width: kScreenW, height: kScreenH-64-50)
        thirdVC.view.frame = CGRect.init(x: kScreenW*2, y: 0, width: kScreenW, height: kScreenH-64-50)
        
        self.addChildViewController(firstVC)
        self.addChildViewController(secondVC)
        self.addChildViewController(thirdVC)
        self.scrollView.addSubview(firstVC.view)
        self.scrollView.addSubview(secondVC.view)
        self.scrollView.addSubview(thirdVC.view)
        
    }
    
    func changeViewWithTag(type:NSInteger) {
        self.scrollView.contentOffset = CGPoint.init(x: kScreenW*CGFloat(type-1000), y:self.scrollView.contentOffset.y)
        if type == self.taskType {
            return
        }
        self.taskType = type
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = NSInteger(scrollView.contentOffset.x/kScreenW)
        self.headView.endScrollViewWithIndex(index:index)
        if 1000+index == self.taskType {
            return
        }
        self.taskType = 1000+index
    }
    
    func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func publishAction() {
        
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
