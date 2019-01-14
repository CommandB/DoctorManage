//
//  CEXPatientInfoView.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2019/1/8.
//  Copyright © 2019年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON

class CEXPatientInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addChildeView()
        layOutChildeView()
    }
    
    func addChildeView() {
        self.addSubview(titleLabel)
        self.addSubview(bgView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(sexLabel)
        bgView.addSubview(ageLabel)
        bgView.addSubview(rightLabel1)
        bgView.addSubview(rightLabel2)
        bgView.addSubview(rightLabel3)
        bgView.addSubview(segment)

    }
    //布局子控件
    func layOutChildeView() {
        titleLabel.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.top.offset()(5)
            make?.right.offset()(0)
        }
        bgView.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.right.offset()(-20)
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(5)
            make?.bottom.equalTo()(0)
        }
        nameLabel.mas_makeConstraints { (make) in
            make?.left.offset()(10)
            make?.top.equalTo()(10)
        }
        sexLabel.mas_makeConstraints { (make) in
            make?.top.offset()(10)
            make?.centerX.offset()(0)
        }
        ageLabel.mas_makeConstraints { (make) in
            make?.right.offset()(-10)
            make?.top.offset()(10)
        }
        
        let leftView1 = createLabel()
        let leftView2 = createLabel()
        let leftView3 = createLabel()
        bgView.addSubview(leftView1)
        bgView.addSubview(leftView2)
        bgView.addSubview(leftView3)
        leftView1.text = "病例号"
        leftView2.text = "主要诊断"
        leftView3.text = "处置操作"
        leftView1.mas_makeConstraints { (make) in
            make?.left.offset()(10)
            make?.top.equalTo()(40)
        }
        leftView2.mas_makeConstraints { (make) in
            make?.left.offset()(10)
            make?.top.equalTo()(leftView1.mas_bottom)?.offset()(10)
        }
        leftView3.mas_makeConstraints { (make) in
            make?.left.offset()(10)
            make?.top.equalTo()(leftView2.mas_bottom)?.offset()(10)
        }
        
        ageLabel.mas_makeConstraints { (make) in
            make?.right.offset()(-10)
            make?.top.offset()(10)
        }
        rightLabel1.mas_makeConstraints { (make) in
            make?.left.equalTo()(leftView1.mas_right)?.offset()(10)
            make?.centerY.equalTo()(leftView1)
        }
        rightLabel2.mas_makeConstraints { (make) in
            make?.left.equalTo()(leftView2.mas_right)?.offset()(10)
            make?.centerY.equalTo()(leftView2)
        }
        rightLabel3.mas_makeConstraints { (make) in
            make?.left.equalTo()(leftView3.mas_right)?.offset()(10)
            make?.centerY.equalTo()(leftView3)
        }
        segment.mas_makeConstraints { (make) in
            make?.right.offset()(-10)
            make?.top.offset()(40)
        }
    }
    
    func dataSource(data:JSON) {
        nameLabel.text = data["studentname"].stringValue
        sexLabel.text = "男"
        ageLabel.text = data["sickage"].stringValue
        rightLabel1.text = data["sickno"].stringValue
        rightLabel2.text = data["diagnosis"].stringValue
        rightLabel3.text = data["operation"].stringValue
        if data["sicktype"].stringValue == "新病人" {
            segment.selectedSegmentIndex = 0
        }else{
            segment.selectedSegmentIndex = 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.lightGray
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }
    //懒加载
    lazy var bgView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 2
        return view
    }()

    lazy var titleLabel:UILabel = {
        let view = UILabel()
        view.textColor = UIColor.lightGray
        view.font = UIFont.systemFont(ofSize: 12)
        view.text = "病人信息"
        return view
    }()
    
    lazy var nameLabel:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.text = "--"
        return view
    }()
    lazy var sexLabel:UILabel = {
        let view = UILabel()
        view.textColor = UIColor.lightGray
        view.text = "--"
        return view
    }()
    lazy var ageLabel:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.text = "--"
        return view
    }()
    
    lazy var rightLabel1:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.text = "--"
        return view
    }()
    lazy var rightLabel2:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.text = "--"
        return view
    }()
    lazy var rightLabel3:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.text = "--"
        return view
    }()
    lazy var segment:UISegmentedControl = {
        let view = UISegmentedControl.init(items: ["新病人","旧病人"])
        view.tintColor = UIColor.blue;
        view.isEnabled = false
        view.selectedSegmentIndex = 0;
        return view
    }()
    
}
