//
//  CompleteDetailController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/9.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class CompleteDetailController: UIViewController {

    @IBOutlet weak var topBackgroundView: UIImageView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var bottomLine: UILabel!
    var headInfo:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(dismissAction))
        scrollview.contentSize = CGSize(width: self.view.bounds.size.width*2, height: scrollview.bounds.size.height)
        
        let subDetailVC = TaskDetailController()
        subDetailVC.headInfo = headInfo
        subDetailVC.enterPath = .COMPLETE
        subDetailVC.view.frame = CGRect(x: 0, y: 0, width: scrollview.bounds.size.width, height: self.view.bounds.size.height-90-49)
        let subValuateVC = SubValuateController()
        subValuateVC.headInfo = headInfo
        subValuateVC.view.frame = CGRect(x: self.view.bounds.size.width, y: 0, width: scrollview.bounds.size.width, height: scrollview.bounds.size.height)
        
        self.addChildViewController(subDetailVC)
        self.addChildViewController(subValuateVC)
        
        scrollview.addSubview(subDetailVC.view)
        scrollview.addSubview(subValuateVC.view)
    }

    @IBAction func didTapBtn(_ sender: Any) {
        bottomLine.center = CGPoint.init(x: (sender as! UIButton).center.x, y:  bottomLine.center.y)
        
        scrollview.contentOffset = CGPoint.init(x: CGFloat((sender as! UIButton).tag-1000) * self.view.bounds.size.width, y: 0)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let btn = self.view.viewWithTag(1000+Int(scrollview.contentOffset.x/self.view.bounds.size.width))
        bottomLine.center = CGPoint.init(x: (btn as! UIButton).center.x, y:  bottomLine.center.y)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
