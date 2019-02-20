//
//  HisCEXTableViewCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/12/30.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit

class HisCEXTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        addChildeView()
        layOutChildeView()
    }
    
    func addChildeView() {
        self.addSubview(leftLabel1)
        self.addSubview(leftLabel2)
        self.addSubview(rightLabel)
        
        self.addSubview(nameLabel)
        self.addSubview(dateLabel)
        self.addSubview(scoreLabel)
    }
    
    func layOutChildeView() {
        leftLabel1.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.bottom.equalTo()(self.mas_centerY)?.offset()(-5);
        }
        leftLabel2.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.top.equalTo()(self.mas_centerY)?.offset()(5);
        }
        rightLabel.mas_makeConstraints { (make) in
            make?.right.offset()(-80)
            make?.bottom.equalTo()(self.mas_centerY)?.offset()(0);
        }
        nameLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(leftLabel1.mas_right)?.offset()(10)
            make?.bottom.equalTo()(self.leftLabel1);
        }
        dateLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(leftLabel2.mas_right)?.offset()(10)
            make?.top.equalTo()(self.leftLabel2);
        }
        scoreLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(rightLabel.mas_right)?.offset()(10)
            make?.bottom.equalTo()(self.rightLabel);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //懒加载
    lazy var leftLabel1:UILabel = {
        let label = UILabel()
        label.text = "被考人"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.lightGray
        return label
    }()
    lazy var leftLabel2:UILabel = {
        let label = UILabel()
        label.text = "考试时间"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.lightGray
        return label
    }()
    lazy var rightLabel:UILabel = {
        let label = UILabel()
        label.text = "得分"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.lightGray
        return label
    }()
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    lazy var dateLabel:UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    lazy var scoreLabel:UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
}
