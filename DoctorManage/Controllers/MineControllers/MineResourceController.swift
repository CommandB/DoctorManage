//
//  MineResourceController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/15.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import MobileCoreServices

class MineResourceController: UIViewController,ELCImagePickerControllerDelegate {
    @IBOutlet weak var topBackgroundView: UIImageView!
    @IBOutlet weak var bottomLine: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.contentSize = CGSize(width: self.view.bounds.size.width*2, height: self.view.frame.size.height-topBackgroundView.bounds.size.height)
        self.automaticallyAdjustsScrollViewInsets = false
        let subResMineVC = SubResMineController()
        subResMineVC.view.frame = CGRect(x: 0, y: 0, width: scrollview.bounds.size.width, height: self.view.bounds.size.height-topBackgroundView.frame.size.height)
        let subresDepartVC = SubResDepartController()
        subresDepartVC.view.frame = CGRect(x: self.view.frame.size.width, y: 0, width: scrollview.bounds.size.width, height: self.view.frame.size.height-topBackgroundView.frame.size.height)
        
        self.addChildViewController(subResMineVC)
        self.addChildViewController(subresDepartVC)
        
        scrollview.addSubview(subResMineVC.view)
        scrollview.addSubview(subresDepartVC.view)
    }

    @IBAction func didTapBtn(_ sender: Any) {
        bottomLine.center = CGPoint.init(x: (sender as! UIButton).center.x, y:  bottomLine.center.y)
        scrollview.contentOffset = CGPoint.init(x: CGFloat((sender as! UIButton).tag-1000) * self.view.bounds.size.width, y: 0)
    }
    
    @IBAction func addVideoBtnTapped(_ sender: Any) {
        let elcPicker = ELCImagePickerController(imagePicker: ())!
        elcPicker.maximumImagesCount = 1
        elcPicker.returnsOriginalImage = false
        elcPicker.returnsImage = false
        elcPicker.onOrder = true
        elcPicker.mediaTypes = [kUTTypeMovie]
        elcPicker.imagePickerDelegate = self
        self.present(elcPicker, animated: true, completion: nil)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let btn = self.view.viewWithTag(1000+Int(scrollview.contentOffset.x/scrollView.bounds.size.width))
        bottomLine.center = CGPoint.init(x: (btn as! UIButton).center.x, y:  bottomLine.center.y)
        if scrollView.contentOffset.x == self.view.frame.size.width {
            if (self.childViewControllers.first as! SubResMineController).player != nil {
                (self.childViewControllers.first as! SubResMineController).player.destroy()
            }
        }else if scrollView.contentOffset.x == 0 {
//            if (self.childViewControllers.first as! SubResMineController).player != nil {
//                (self.childViewControllers.first as! SubResMineController).player.destroy()
//            }
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:ELCImagePickerControllerDelegate
    func elcImagePickerController(_ picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [Any]!) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let passVideoViewVC = storyboard.instantiateViewController(withIdentifier: "PassVideoView")
        picker?.pushViewController(passVideoViewVC, animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    func elcImagePickerControllerDidCancel(_ picker: ELCImagePickerController!) {
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
