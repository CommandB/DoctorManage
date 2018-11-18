//
//  EvaluateTopSelectView.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/18.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SnapKit

class EvaluateTopSelectView: UIView {
    var saveButtonArry = NSMutableArray()
    typealias funcBlock = (_ tag : NSInteger) -> ()
    var buttonClickCallBack : funcBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGBCOLOR(r: 240, 240, 240)
        addChildeView()
        layOutChildeView()
    }
    
    func addChildeView() {
        let titles = ["待考任务","待评任务","Mini-CEX","调查问卷"];

        for index in 0...3 {
            let button = createButtonWithTitle(title: titles[index], tag: 1000+index)
            self.addSubview(button)
            self.saveButtonArry.add(button)
        }
        self.addSubview(self.indicatorview)
    }
    //布局子控件
    func layOutChildeView() {
        self.saveButtonArry.mas_distributeViews(along: .horizontal, withFixedSpacing: 0, leadSpacing: 0, tailSpacing: 0)
        self.saveButtonArry.mas_makeConstraints { (make) in
            make?.top.offset()(5)
            make?.height.offset()(45)
        }
        guard let firstButton = self.viewWithTag(1000) else { return }
        self.indicatorview.mas_makeConstraints { (make) in
            make?.height.equalTo()(2)
            make?.centerX.equalTo()(firstButton.mas_centerX)
            make?.bottom.offset()(0)
            make?.width.equalTo()(65)
        }
    }
    
    func createButtonWithTitle(title:String, tag:NSInteger) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        btn.tag = tag
        if tag == 1000 {
            btn.setTitleColor(RGBCOLOR(r: 56, 146, 246), for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        }
        return btn
    }
    
    func buttonClick(btn:UIButton) {
        self.indicatorview.mas_remakeConstraints { (make) in
            make?.height.equalTo()(2)
            make?.centerX.equalTo()(btn.mas_centerX)
            make?.bottom.offset()(0)
            make?.width.equalTo()(65)
        }
        if let callBack = buttonClickCallBack {
            callBack(btn.tag)
        }
        
        for index in 0...3 {
            if let button = self.viewWithTag(1000+index) as? UIButton {
                button.setTitleColor(UIColor.black, for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            }
        }
        btn.setTitleColor(RGBCOLOR(r: 56, 146, 246), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
    }
    
    func endScrollViewWithIndex(index:NSInteger) {
        guard let selectedButton = self.viewWithTag(1000+index) as? UIButton else { return }

        self.indicatorview.mas_remakeConstraints { (make) in
            make?.height.equalTo()(2)
            make?.centerX.equalTo()(selectedButton)
            make?.bottom.offset()(0)
            make?.width.equalTo()(65)
        }
        
        for index in 0...3 {
            if let button = self.viewWithTag(1000+index) as? UIButton {
                button.setTitleColor(UIColor.black, for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            }
        }
        selectedButton.setTitleColor(RGBCOLOR(r: 56, 146, 246), for: .normal)
        selectedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //懒加载
    //指示的view
    lazy var indicatorview:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(r: 54, g: 137, b: 230)
        return view
    }()
}
