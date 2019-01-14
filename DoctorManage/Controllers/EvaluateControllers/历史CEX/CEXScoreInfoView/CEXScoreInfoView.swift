//
//  CEXScoreInfoView.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2019/1/8.
//  Copyright © 2019年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON

class CEXScoreInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addChildeView()
        layOutChildeView()
    }
    
    func addChildeView() {
        self.addSubview(titleLabel)
        self.addSubview(segment)
        self.addSubview(bgView)
        
        let array1 = NSMutableArray(array: ["0","0","0","0","0","0","0"])
        ccView.setDataSource(array1)
        bgView.addSubview(ccView)
        
        
        let array2 = NSMutableArray(array: ["0","0","0","0","0","0","0"])
        ddView.setDataSource(array2)
        bgView.addSubview(ddView)
        
        
        
        
        
//        let vc = DDViewController()
//        vc.view.frame = CGRect.init(x: 0, y: 0, width: kScreenW-40, height: 400)
//        bgView.addSubview(vc.view)
    
//        let radarChartView = RadarChartView(frame: CGRect.init(x: 0, y: 0, width: kScreenW-40, height: 400))
//        radarChartView.center = bgView.center;
//        bgView.addSubview(radarChartView)
//        radarChartView.rotationEnabled = true
//        radarChartView.highlightPerTapEnabled = false
//        
//        radarChartView.webLineWidth = 1
//        radarChartView.webColor = .lightGray
//        radarChartView.innerWebLineWidth = 1
//        radarChartView.innerWebColor = .lightGray
//        radarChartView.webAlpha = 0.5
//        
//        let markerY = MarkerView()
//        markerY.offset = CGPoint.init(x: -17, y: -25)
//        markerY.chartView
//        
        
        
    }
    
    func sementedControlClick() {
        if segment.selectedSegmentIndex == 0 {
            ddView.isHidden = true
        }else{
            ddView.isHidden = false
        }
    }
    
    //布局子控件
    func layOutChildeView() {
        titleLabel.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.bottom.equalTo()(segment)
            make?.right.offset()(0)
        }
        segment.mas_makeConstraints { (make) in
            make?.top.offset()(5)
            make?.right.offset()(-20)
        }
        bgView.mas_makeConstraints { (make) in
            make?.left.offset()(20)
            make?.right.offset()(-20)
            make?.top.equalTo()(segment.mas_bottom)?.offset()(5)
            make?.bottom.equalTo()(0)
        }
        
       
        
    }
    
    func dataSource(data:JSON) {
        let array1 = NSMutableArray(array: [data["inquiryscore"].stringValue,data["checkscore"].stringValue,data["czjnscore"].stringValue,data["lcpdscore"].stringValue,data["jkxjscore"].stringValue,data["zzxnscore"].stringValue,data["rwghscore"].stringValue])
        ccView.setDataSource(array1)
        
        
        let array2 = NSMutableArray(array: [data["inquiryscore"].stringValue,data["checkscore"].stringValue,data["czjnscore"].stringValue,data["lcpdscore"].stringValue,data["jkxjscore"].stringValue,data["zzxnscore"].stringValue,data["rwghscore"].stringValue])
        ddView.setDataSource(array2)
        
        
        
        
        
        
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
        view.text = "成绩信息"
        return view
    }()
    
    lazy var segment:UISegmentedControl = {
        let view = UISegmentedControl.init(items: ["柱状图","雷达图"])
        view.tintColor = UIColor.blue;
        view.selectedSegmentIndex = 0;
        view.addTarget(self, action: #selector(sementedControlClick), for: .valueChanged)
        return view
    }()
    
    lazy var ddView:DDView = {
        let view = DDView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW-40, height: 420))
        let array = NSMutableArray(array: ["0","0","0","0","0","0","0"])
        view.setDataSource(array)
        view.isHidden = true
        return view
    }()
    
    lazy var ccView:CCView = {
        let view = CCView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW-40, height: 420))
        view.isHidden = false

        
        return view
    }()
    
    
}
