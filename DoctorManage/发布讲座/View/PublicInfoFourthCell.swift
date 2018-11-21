//
//  PublicInfoFourthCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/20.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit

class PublicInfoFourthCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.isUserInteractionEnabled = true
        addChildeView()
        layOutChildeView()
    }
    
    func addChildeView() {
        self.addSubview(titleLabel)
        self.addSubview(firstButton)
        self.addSubview(secondButton)
        self.addSubview(thirdButton)
        self.addSubview(firstLabel)
        self.addSubview(secondLabel)
        self.addSubview(thirdLabel)
    }
    
    func layOutChildeView() {
        titleLabel.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.centerY.offset()(0)
        }
        firstButton.mas_makeConstraints { (make) in
            make?.left.offset()(kScreenW/4)
            make?.centerY.offset()(0)
            make?.size.mas_equalTo()(CGSize.init(width: 17, height: 17))
        }
        secondButton.mas_makeConstraints { (make) in
            make?.left.offset()(kScreenW*2/4)
            make?.centerY.offset()(0)
            make?.size.mas_equalTo()(CGSize.init(width: 17, height: 17))
        }
        thirdButton.mas_makeConstraints { (make) in
            make?.left.offset()(kScreenW*3/4)
            make?.centerY.offset()(0)
            make?.size.mas_equalTo()(CGSize.init(width: 17, height: 17))
        }
        
        firstLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(firstButton.mas_right)?.offset()(2)
            make?.centerY.offset()(0)
        }
        secondLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(secondButton.mas_right)?.offset()(2)
            make?.centerY.offset()(0)
        }
        thirdLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(thirdButton.mas_right)?.offset()(2)
            make?.centerY.offset()(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func touchDown(selectButton:UIButton) {
        for index in 1000...1002 {
            if let button = self.viewWithTag(index) as? UIButton {
                button.isSelected = false
            }
        }
        selectButton.isSelected = true
    }
    
    //懒加载
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "签到方式"
        return label
    }()
    
    lazy var firstButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "public_unselect"), for: .normal)
        button.setImage(UIImage.init(named: "public_select"), for: .selected)
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.tag = 1000
        return button
    }()
    
    lazy var secondButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "public_unselect"), for: .normal)
        button.setImage(UIImage.init(named: "public_select"), for: .selected)
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.tag = 1001
        return button
    }()
    
    lazy var thirdButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "public_unselect"), for: .normal)
        button.setImage(UIImage.init(named: "public_select"), for: .selected)
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.tag = 1002
        return button
    }()
    
    lazy var firstLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "签到"
        return label
    }()
    
    lazy var secondLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "签到+签出"
        return label
    }()
    
    lazy var thirdLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "未签到"
        return label
    }()
    
}
