//
//  PassVideoViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/24.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class PassVideoViewController: UIViewController {
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var widthConstrain: NSLayoutConstraint!
    @IBOutlet weak var bottomImageview: UIImageView!
    @IBOutlet weak var subPassImageView: UIImageView!
    @IBOutlet weak var subPassingLabel: UILabel!
    @IBOutlet weak var passBtn: UIButton!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "topBackgroundIcon"), for: .default)
        self.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.title = "视频上传"
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(backAction))
//        tableview.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        tableview.delegate = self
//        tableview.dataSource = self
//        self.view.addSubview(tableview)
//        let nib1 = UINib(nibName: "EvaluateBaseCell", bundle: nil)
//        tableview.register(nib1, forCellReuseIdentifier: "EvaluateBaseCell")
        
        self.widthConstrain.constant = 0
        
        
        var time = 0
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (void) in
                time = time + 1
                self.widthConstrain.constant = CGFloat(40 * time)
                if self.widthConstrain.constant >= self.bottomImageview.frame.size.width{
                    self.timer.invalidate()
                    self.widthConstrain.constant = self.bottomImageview.frame.size.width
                    self.passBtn.backgroundColor = UIColor.init(red: 199/255.0, green: 211/255.0, blue: 224/255.0, alpha: 1.0)
                    self.subPassImageView.image = UIImage.init(named: "已完成")
                    self.subPassingLabel.text = "已完成"
                    
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    
    }
    
//    func runTime() {
//        time = time + 1
//        self.widthConstrain.constant = CGFloat(40 * time)
//        if self.widthConstrain.constant >= self.bottomImageview.frame.size.width{
//            self.widthConstrain.constant = self.bottomImageview.frame.size.width
//            self.passBtn.backgroundColor = UIColor.init(red: 199/255.0, green: 211/255.0, blue: 224/255.0, alpha: 1.0)
//            self.subPassImageView.image = UIImage.init(named: "已完成")
//            self.subPassingLabel.text = "已完成"
//            self.timer.invalidate()
//        }
//    }

    func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
