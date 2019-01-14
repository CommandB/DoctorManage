//
//  HisCEXDetailViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2019/1/1.
//  Copyright © 2019年 chenshengchang. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class HisCEXDetailViewController: IGBaseViewController {
    var dataSource:JSON = JSON()
    
    let chartView = HorizontalBarChartView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "CEX详情"
        addChildViews()
    }

    func addChildViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(patientView)
        scrollView.addSubview(scoreView)
        patientView.dataSource(data: dataSource)
        scoreView.dataSource(data: dataSource)
        
        
        let cexEvaluateView = CEXEvaluateView(frame: CGRect.init(x: 0, y: scoreView.frame.maxY+10, width: kScreenW, height: 575))
        cexEvaluateView.dataSource(data: dataSource)
        
        
        scrollView.addSubview(cexEvaluateView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    lazy var scrollView:UIScrollView = {
        let view = UIScrollView(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH-64))
        view.contentSize = CGSize.init(width: 0, height: 1200)
        return view
    }()
    lazy var patientView:CEXPatientInfoView = {
        let view = CEXPatientInfoView(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 150))
        return view
    }()
    lazy var scoreView:CEXScoreInfoView = {
        let view = CEXScoreInfoView(frame: CGRect.init(x: 0, y: 165, width: kScreenW, height: 450))
        return view
    }()
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
