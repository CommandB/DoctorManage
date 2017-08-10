//
//  TaskCenterViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/2.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class TaskCenterViewController: UIViewController {
    @IBOutlet weak var topBackgroundView: UIImageView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var bottomLine: UILabel!
    
    
    var stackView: UIStackView!
    private var buttons: [UIButton]         = []
    private var dataSource:[NSDictionary]   = []
    private var currentIndex:Int   = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollview.contentSize = CGSize(width: self.view.bounds.size.width*3, height: scrollview.bounds.size.height)
        self.automaticallyAdjustsScrollViewInsets = false
        let unCompleteVC = UnCompleteController()
        unCompleteVC.view.frame = CGRect(x: 0, y: 0, width: scrollview.frame.size.width, height: scrollview.bounds.size.height)

        let completeVC = CompleteController()
        completeVC.view.frame = CGRect(x: self.view.bounds.size.width, y: 0, width: scrollview.frame.size.width, height: scrollview.bounds.size.height)
        
        self.addChildViewController(unCompleteVC)
        self.addChildViewController(completeVC)
        
        scrollview.addSubview(unCompleteVC.view)
        scrollview.addSubview(completeVC.view)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapBtn(_ sender: Any) {
        bottomLine.center = CGPoint.init(x: (sender as! UIButton).center.x, y:  bottomLine.center.y)
        
        scrollview.contentOffset = CGPoint.init(x: CGFloat((sender as! UIButton).tag-1000) * self.view.bounds.size.width, y: 0)
        
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let btn = self.view.viewWithTag(1000+Int(scrollview.contentOffset.x/self.view.bounds.size.width))
        bottomLine.center = CGPoint.init(x: (btn as! UIButton).center.x, y:  bottomLine.center.y)
    }
    
    override func viewDidLayoutSubviews() {
        let btn = self.view.viewWithTag(1000+Int(scrollview.contentOffset.x/self.view.bounds.size.width))
        bottomLine.center = CGPoint.init(x: (btn as! UIButton).center.x, y:  bottomLine.center.y)
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
