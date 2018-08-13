//
//  JHMyTaskDetaiController.swift
//  DoctorManage
//
//  Created by chenhaifeng on 2018/8/10.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
class JHMyTaskDetaiController: UIViewController {
    var headDataJson = JSON.init("")
    var teachingmaterialJson = JSON.init("")
    let c : CircleDataView = CircleDataView()
    
    @IBOutlet weak var btn_start: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func btn_back_inside(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //开始执行
    @IBAction func btn_start_inside(_ sender: UIButton) {
//        let vc = getViewToStoryboard("videoView") as! VideoController
//        vc.headData = teachingmaterialJson
//        vc.complate = headDataJson["student_state"].stringValue
//        vc.taskId = headDataJson["taskid"].stringValue
//        present(vc, animated: true, completion: nil)
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
