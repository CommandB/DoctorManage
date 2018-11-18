//
//  PublishLectureController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/10.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit

class PublishLectureController: JHBaseViewController {
    var headView = PublishLectureHeadView()
    var beforeIndex:NSInteger = 99
    var buttonClick = false
    
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
            self.beforeIndex = tag.rawValue
            self.buttonClick = true
        }
    }
    
    func changeViewWithTag(type:lectureTypeButton) {
        switch type {
        case .lectureTypeButtonBasic:
            
            break
        case .lectureTypeButtonStudents:
            
            break
        case .lectureTypeButtonFile:
            
            break
        }
        
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
