//
//  TaskCenterRootController.swift
//  DoctorManage
//
//  Created by chenhaifeng on 2018/8/10.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SnapKit
class TaskCenterRootController: UIViewController{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var botttomLine: UIView!
    @IBOutlet weak var myTaskBtn: UIButton!
    @IBOutlet weak var myTeachBtn: UIButton!
    @IBOutlet weak var topbackView: UIView!
    @IBOutlet weak var historyBtn: UIButton!
    
    let myTaskView = JHMyTaskViewController()
    let myTeachView = JHMyTeachViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarColor()
        configUI()
    }

    func configUI() {
        scrollView.contentSize = CGSize(width: kScreenWidth*2, height: 0)
        scrollView.isScrollEnabled = false

        scrollView.addSubview(myTaskView.view)
        scrollView.addSubview(myTeachView.view)
        self.addChildViewController(myTaskView)
        self.addChildViewController(myTeachView)
        
        myTaskView.view.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
        myTeachView.view.snp.makeConstraints { (make) in
            make.size.top.equalToSuperview()
            make.left.equalTo(kScreenWidth)
        }
    }
    
    
    @IBAction func switchTypeAction(_ sender: UIButton) {
        botttomLine.center = CGPoint(x: sender.center.x, y: botttomLine.center.y)
        if sender == myTaskBtn {
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }else{
            scrollView.contentOffset = CGPoint(x: kScreenWidth, y: scrollView.contentOffset.y)
        }
    }
    
    @IBAction func scanAction(_ sender: UIButton) {
        myPresentView(self, viewName: "scannerView")
    }
    
    @IBAction func tapHistoryBtn(_ sender: UIButton) {
        let completeView = CompleteController()
        let nav = UINavigationController.init(rootViewController: completeView)
        self.present(nav, animated: true, completion: nil)
    }
    
    ///设置标题的渐变背景色
    func setNavigationBarColor(){
        let navigationBarColor = CAGradientLayer()
        navigationBarColor.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        navigationBarColor.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        navigationBarColor.colors = [UIColor.init(hex: "74c0e0").cgColor,UIColor.init(hex: "407bd8").cgColor]
        topbackView.layer.insertSublayer(navigationBarColor, at: 0)
//        topbackView?.layer.addSublayer(navigationBarColor)
        navigationBarColor.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 110)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
