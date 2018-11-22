//
//  PublicInfoFiveCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/20.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit

class PublicInfoFiveCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        addChildeView()
        layOutChildeView()
    }
    
    func addChildeView() {
        self.addSubview(titleLabel)
        self.addSubview(leftLabel1)
        self.addSubview(leftLabel2)
        self.addSubview(switchBtn1)
        self.addSubview(switchBtn2)
        self.addSubview(line1)
        self.addSubview(line2)
    }
    
    func layOutChildeView() {
        titleLabel.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.centerY.equalTo()(self.mas_centerY)?.multipliedBy()(0.33);
        }
        leftLabel1.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.centerY.offset()(0);
        }
        leftLabel2.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.centerY.equalTo()(self.mas_centerY)?.multipliedBy()(1.67);
        }
        switchBtn1.mas_makeConstraints { (make) in
            make?.right.offset()(-20)
            make?.centerY.offset()(0);
        }
        switchBtn2.mas_makeConstraints { (make) in
            make?.right.offset()(-20)
            make?.centerY.equalTo()(self.mas_centerY)?.multipliedBy()(1.67);
        }
        line1.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.right.offset()(0)
            make?.height.equalTo()(0.5)
            make?.centerY.equalTo()(self.mas_centerY)?.multipliedBy()(0.67);
        }
        line2.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.right.offset()(0)
            make?.height.equalTo()(0.5)
            make?.centerY.equalTo()(self.mas_centerY)?.multipliedBy()(1.33);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //懒加载
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "评价功能"
        return label
    }()
    
    lazy var leftLabel1:UILabel = {
        let label = UILabel()
        label.text = "学员对老师"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var leftLabel2:UILabel = {
        let label = UILabel()
        label.text = "老师对学员"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var switchBtn1:UISwitch = {
        let switch1 = UISwitch()
        switch1.isOn = false
        return switch1
    }()
    lazy var switchBtn2:UISwitch = {
        let switch2 = UISwitch()
        switch2.isOn = false
        return switch2
    }()
    
    lazy var line1:UILabel = {
        let line = UILabel()
        line.backgroundColor = UIColor.graySeparateLineColor()
        return line
    }()
    
    lazy var line2:UILabel = {
        let line = UILabel()
        line.backgroundColor = UIColor.graySeparateLineColor()
        return line
    }()
}
