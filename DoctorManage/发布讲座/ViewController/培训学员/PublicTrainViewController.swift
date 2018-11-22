//
//  PublicTrainViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/20.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit

class PublicTrainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViews()
    }

    func addChildViews() {
        self.view.addSubview(addStudentsButton)
    }
    
    func selectTrainsPeopleAction() {
        
    }
    
    lazy var addStudentsButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = RGBCOLOR(r: 45, 114, 192)
        btn.setTitle("添加人员", for: .normal)
        btn.frame = CGRect.init(x: 0, y: kScreenH-64-50-50, width: kScreenW, height: 50)
        btn.addTarget(self, action: #selector(selectTrainsPeopleAction), for: .touchUpInside)
        return btn
    }()

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
