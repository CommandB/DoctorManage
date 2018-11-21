//
//  PublicInfoSecondCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/20.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit

class PublicInfoSecondCell: UITableViewCell {
    let beginDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    var beginDateFormatter = DateFormatter()
    var endDateFormatter = DateFormatter()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.isUserInteractionEnabled = true
        addChildeView()
        layOutChildeView()
        setInputView()
    }

    func addChildeView() {
        self.addSubview(startLabel)
        self.addSubview(endLabel)
        self.addSubview(durHours)
        self.addSubview(startTimeField)
        self.addSubview(endTimeField)
        self.addSubview(centerLabel)

    }
    
    func layOutChildeView() {
        startLabel.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.top.offset()(10)
        }
        endLabel.mas_makeConstraints { (make) in
            make?.right.offset()(-20)
            make?.centerY.equalTo()(startLabel.mas_centerY)
        }
        durHours.mas_makeConstraints { (make) in
            make?.centerX.offset()(0)
            make?.top.offset()(10)
            make?.centerY.equalTo()(startLabel.mas_centerY)
            make?.size.equalTo()(CGSize.init(width: 100, height: 30))
        }
        durHours.backgroundColor = .gray
        startTimeField.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.top.equalTo()(startLabel.mas_bottom)?.offset()(5)
        }
        endTimeField.mas_makeConstraints { (make) in
            make?.right.offset()(-20)
            make?.top.equalTo()(startLabel.mas_bottom)?.offset()(5)
        }
        
        centerLabel.mas_makeConstraints { (make) in
            make?.centerX.offset()(0)
            make?.top.equalTo()(startLabel.mas_bottom)?.offset()(5)
        }
        
    }
    
    func setInputView() {
        beginDatePicker.datePickerMode = .dateAndTime
        beginDatePicker.addTarget(self, action: #selector(beginDateChanged), for: .valueChanged)
        startTimeField.addTarget(self, action: #selector(beginDateChanged), for: .editingDidBegin)
        beginDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        endDatePicker.datePickerMode = .dateAndTime
        endDatePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        endTimeField.addTarget(self, action: #selector(endDateChanged), for: .editingDidBegin)
        endDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        startTimeField.inputView = beginDatePicker
        endTimeField.inputView = endDatePicker
    }
    
    func beginDateChanged() {
        endDatePicker.endEditing(false)
        startTimeField.text = beginDateFormatter.string(from: beginDatePicker.date)
    }

    func endDateChanged() {
        beginDatePicker.endEditing(true)
        endTimeField.text = endDateFormatter.string(from: endDatePicker.date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
//
//    //懒加载
    lazy var startLabel:UILabel = {
        let label = UILabel()
        label.text = "开始"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var endLabel:UILabel = {
        let label = UILabel()
        label.text = "结束"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var durHours:UILabel = {
        let label = UILabel()
        label.text = "时长：0"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var startTimeField:UITextField = {
        let field = UITextField()
        field.placeholder = "选择开始时间"
        field.font = UIFont.systemFont(ofSize: 14)
        field.isUserInteractionEnabled = true
        return field
    }()
    
    lazy var endTimeField:UITextField = {
        let field = UITextField()
        field.placeholder = "选择结束时间"
        field.font = UIFont.systemFont(ofSize: 14)
        field.isUserInteractionEnabled = true
        return field
    }()
    
    lazy var centerLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "至"
        return label
    }()
    
    
}
