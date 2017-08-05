//
//  MineEvaluateController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/15.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class MineEvaluateController: UIViewController {
    @IBOutlet weak var topBackgroundView: UIImageView!
    @IBOutlet weak var bottomLine: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.contentSize = CGSize(width: self.view.bounds.size.width*2, height: self.view.frame.size.height-topBackgroundView.bounds.size.height)
        let subEvaTeachVC = SubEvaTeachController()
        subEvaTeachVC.view.frame = CGRect(x: 0, y: 0, width: scrollview.bounds.size.width, height: self.view.bounds.size.height-topBackgroundView.frame.size.height)
        let subEvatrainVC = SubEvaTrainController()
        subEvatrainVC.view.frame = CGRect(x: self.view.bounds.size.width, y: 0, width: scrollview.bounds.size.width, height: self.view.frame.size.height-topBackgroundView.frame.size.height)
        
        self.addChildViewController(subEvaTeachVC)
        self.addChildViewController(subEvatrainVC)
        
        scrollview.addSubview(subEvaTeachVC.view)
        scrollview.addSubview(subEvatrainVC.view)
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
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
