//
//  PublicInfoFirstCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/20.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit

class PublicInfoFirstCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        addChildeView()
        layOutChildeView()
    }

    func addChildeView() {
        self.addSubview(textField)
    }
    
    func layOutChildeView() {
        textField.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.centerY.width().right().offset()(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //懒加载
    lazy var textField:UITextField = {
        let fieldView = UITextField()
        fieldView.placeholder = "主题"
        return fieldView
    }()
}
