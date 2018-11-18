//
//  PublishLectureHeadView.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/10.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SnapKit
enum lectureTypeButton:Int {
    case lectureTypeButtonBasic = 99 //基础信息
    case lectureTypeButtonStudents   //培训学员
    case lectureTypeButtonFile       //附件
}

class PublishLectureHeadView: UIView {
    //基础信息按钮
    var basicButton = UIButton()
    //培训学员按钮
    var studentsButton = UIButton()
    //附件按钮
    var fileButton = UIButton()
    //之前的按钮
    var beforeButton:UIButton?
    //之前的偏移
    var beforeOffset:CGFloat = 0
    //当前索引
    var currentIndex:NSInteger = 0
    //下一个索引
    var nextIndex:NSInteger = 0
    
    var saveButtonArry = NSMutableArray()
    
    typealias funcBlock = (_ tag : lectureTypeButton) -> ()
    var buttonClickCallBack : funcBlock?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addChildeView()
        layOutChildeView()
    }
    
    func addChildeView() {
        self.basicButton = createButtonWithTitle(title: "基础信息", tag: .lectureTypeButtonBasic)
        self.studentsButton = createButtonWithTitle(title: "培训学员", tag: .lectureTypeButtonStudents)
        self.fileButton = createButtonWithTitle(title: "附件", tag: .lectureTypeButtonFile)
        self.addSubview(self.basicButton)
        self.addSubview(self.studentsButton)
        self.addSubview(self.fileButton)

        self.saveButtonArry.add(self.basicButton)
        self.saveButtonArry.add(self.studentsButton)
        self.saveButtonArry.add(self.fileButton)
        self.addSubview(self.indicatorview)
    }
    //布局子控件
    func layOutChildeView() {
        self.saveButtonArry.mas_distributeViews(along: .horizontal, withFixedSpacing: 0, leadSpacing: 0, tailSpacing: 0)
        self.saveButtonArry.mas_makeConstraints { (make) in
            make?.top.offset()(5)
            make?.height.offset()(50)
        }
        self.indicatorview.mas_makeConstraints { (make) in
            make?.height.equalTo()(2)
            make?.centerX.equalTo()(self.basicButton.mas_centerX)
            make?.bottom.offset()(1)
            make?.width.equalTo()(65)
        }
        
        self.beforeButton = self.basicButton
        self.basicButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.basicButton.isSelected = true
    }
    
    func buttonClick(btn:UIButton) {
        if let button = self.beforeButton,button.tag != btn.tag  {
            self.beforeButton?.isSelected = false
        }else{
            return
        }
        self.beforeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.beforeButton?.isSelected = false
        btn.isSelected = !btn.isSelected
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        UIView.animate(withDuration: 0.25) {
            self.indicatorview.center = CGPoint(x: btn.center.x, y: 50)
        }
        
        if let callButton = buttonClickCallBack {
            callButton(lectureTypeButton(rawValue: btn.tag)!)
        }
        self.beforeButton = btn
    }
    
    func createButtonWithTitle(title:String, tag:lectureTypeButton) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        btn.tag = tag.rawValue
        return btn
    }
    
    func changeIndicatorCneterWithOffset(offset:CGFloat,beforeOffset:CGFloat,currentIndex:NSInteger) {
        //获取每个中心点的偏移
        let margin = self.studentsButton.center.x - self.basicButton.center.x
        if let nextButton = self.saveButtonArry.object(at: self.currentIndex) as? UIButton {
            self.indicatorview.center = CGPoint(x: nextButton.center.x+(offset/kScreenW)*margin, y: 50)
        }
        
    }
    
    func endScrollWithIndex(index:NSInteger) {
        self.nextIndex = index
        self.beforeButton?.isSelected = false
        self.beforeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        if let btn = self.saveButtonArry.object(at: index) as? UIButton {
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.isSelected = true
            self.beforeButton = btn
        }
    }
    
    func beginScrollIndex(index:NSInteger) {
        self.currentIndex = index
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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
