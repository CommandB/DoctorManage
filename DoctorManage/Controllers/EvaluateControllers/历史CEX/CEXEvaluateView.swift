//
//  CEXEvaluateView.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2019/1/6.
//  Copyright © 2019年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON

class CEXEvaluateView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addChildeView()
        setMasoryLayout()
    }
    
    func addChildeView() {
        self.addSubview(titleLabel)
        self.addSubview(bgView)

        bgView.addSubview(firstLabel)
        bgView.addSubview(secondLabel)
        bgView.addSubview(thirdLabel)
        bgView.addSubview(firstTextView)
        bgView.addSubview(secondTextView)
        bgView.addSubview(thirdTextView)
    }
    
    func setMasoryLayout() {
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
        for index in 0...2 {
            let barView = KDGoalBar(frame: CGRect.init(x: (kScreenW-40)/3*CGFloat(index), y: 0, width: (kScreenW-40)/3, height: (kScreenW-40)/3));
            barView.tag = 1000+index
            bgView.addSubview(barView);
            switch index {
            case 0:
                barView.setScore("0.00", name: "老师评分", animated: false)
                break
            case 1:
                barView.setScore("0.00", name: "学生评分", animated: false)
                break
            case 2:
                barView.setScore("0.00", name: "病人评分", animated: false)
                break
            default:
                break
            }
        }
        
       
        
        firstLabel.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(115)
            make?.height.equalTo()(40)
        }
        secondLabel.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.top.equalTo()(firstTextView.mas_bottom)?.offset()(5)
            make?.height.equalTo()(40)
        }
        thirdLabel.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.top.equalTo()(secondTextView.mas_bottom)?.offset()(5)
            make?.height.equalTo()(40)
        }
        firstTextView.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.right.offset()(-40)
            make?.width.equalTo()(self)?.offset()(-80)
            make?.top.equalTo()(firstLabel.mas_bottom)?.offset()(0)
            make?.height.equalTo()(80)
        }
        secondTextView.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.right.offset()(-40)
            make?.top.equalTo()(secondLabel.mas_bottom)?.offset()(0)
            make?.height.equalTo()(80)
        }
        thirdTextView.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.right.offset()(-40)
            make?.top.equalTo()(thirdLabel.mas_bottom)!.offset()(0)
            make?.height.equalTo()(80)
        }
        firstTextView.text = ""
        secondTextView.text = ""
        thirdTextView.text = ""
    }

    //布局子控件
    func layOutChildeView(data:JSON) {
        if let view = bgView.viewWithTag(1000) as? KDGoalBar{
            view.setScore(data["teacherassess"].stringValue, name: "老师评分", animated: false)
        }
        if let view = bgView.viewWithTag(1001) as? KDGoalBar{
            view.setScore(data["studentassess"].stringValue, name: "学生评分", animated: false)
        }
        if let view = bgView.viewWithTag(1002) as? KDGoalBar{
            view.setScore(data["sickassess"].stringValue, name: "病人评分", animated: false)
        }
        firstTextView.text = data["fine"].stringValue
        secondTextView.text = data["bad"].stringValue
        thirdTextView.text = data["suggest"].stringValue
    }
    
    func dataSource(data:JSON) {
        layOutChildeView(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        view.text = "评价信息"
        return view
    }()
    lazy var firstTextView:UITextView = {
        let view = UITextView()
        view.text = ""
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    lazy var secondTextView:UITextView = {
        let view = UITextView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.text = ""
        return view
    }()
    lazy var thirdTextView:UITextView = {
        let view = UITextView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.text = ""
        return view
    }()

    lazy var firstLabel:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.text = "值得肯定"
        return view
    }()
    lazy var secondLabel:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.text = "有待加强"
        return view
    }()
    lazy var thirdLabel:UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.text = "今后努力的方向"
        return view
    }()


}
