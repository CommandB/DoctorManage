//
//  PublicInfoThirdCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/20.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit

class PublicInfoThirdCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.selectionStyle = .none
        addChildeView()
        layOutChildeView()
    }
    
    func addChildeView() {
        self.addSubview(titleLabel)
        self.addSubview(detailLabel)
        self.addSubview(arrowView)
    }
    
    func layOutChildeView() {
        titleLabel.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.centerY.offset()(0)
        }
        detailLabel.mas_makeConstraints { (make) in
            make?.right.equalTo()(arrowView.mas_left)?.offset()(-5)
            make?.centerY.offset()(0)
        }
        arrowView.mas_makeConstraints { (make) in
            make?.right.offset()(-15)
            make?.centerY.offset()(0)
            make?.size.equalTo()(CGSize.init(width: 20, height: 20))
        }
    }
    
    func setData(indexpath:IndexPath) {
        if indexpath.row == 0 {
            titleLabel.text = "地点"
            detailLabel.text = "默认常用地址"
        }else if indexpath.row == 1 {
            titleLabel.text = "主讲人"
            detailLabel.text = "默认常用老师"
        }else{
            titleLabel.text = "记录人"
            detailLabel.text = "默认常用记录人"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //懒加载
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var detailLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var arrowView:UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "进入")
        return view
    }()
}
