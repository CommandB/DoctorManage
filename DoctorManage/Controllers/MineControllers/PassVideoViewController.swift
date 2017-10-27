//
//  PassVideoViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/24.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AVFoundation

class PassVideoViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var widthConstrain: NSLayoutConstraint!
    @IBOutlet weak var bottomImageview: UIImageView!
    @IBOutlet weak var subPassImageView: UIImageView!
    @IBOutlet weak var subPassingLabel: UILabel!
    @IBOutlet weak var passBtn: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    var timer = Timer()
    var headImage = UIImage()
    var receiveData = Data()
    var receiveUrl = URL.init(string: "")
    
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
        
        
        //        var time = 0
        //        if #available(iOS 10.0, *) {
        //            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (void) in
        //                time = time + 1
        //                self.widthConstrain.constant = CGFloat(40 * time)
        //                if self.widthConstrain.constant >= self.bottomImageview.frame.size.width{
        //                    self.timer.invalidate()
        //                    self.widthConstrain.constant = self.bottomImageview.frame.size.width
        //                    self.passBtn.backgroundColor = UIColor.init(red: 199/255.0, green: 211/255.0, blue: 224/255.0, alpha: 1.0)
        //                    self.subPassImageView.image = UIImage.init(named: "已完成")
        //                    self.subPassingLabel.text = "已完成"
        //
        //                    self.navigationController?.dismiss(animated: true, completion: nil)
        //                }
        //            }
        //        } else {
        //            // Fallback on earlier versions
        //        }
        //
        
        bottomImageview.image =  self.generateThumbImage(url: receiveUrl!)
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
    
    
    func passVideoRequest() {
        MBProgressHUD.showMessage("上传中", to: self.navigationController?.view)
        let urlString = "http://"+Ip_port2+"doctor_train/rest/teachingMaterial/add_android.do"
        NetworkTool.sharedInstance.uploadVideo(urlString, videoData: [inputTextField.text ?? "testVideo":receiveData], parameters: ["token":UserInfo.instance().token]) { (dataResponse) in
            MBProgressHUD.hide(for: self.navigationController?.view, animated: true)
            switch dataResponse.result{
            case .success:
                print("上传视频成功")
                let alert = UIAlertController.init(title: nil, message: "上传成功", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                DispatchQueue.global().async {
                    Thread.sleep(forTimeInterval: 2.0)
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true, completion: {
                            NotificationCenter.default.post(name:NSNotification.Name(rawValue: kUploadVideoSuccessNotification), object: nil)
                        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        })
                    }
                }
            case .failure:
                MBProgressHUD.showMessage("上传失败", to: self.view)
                print("上传视频失败")
            }
        }
        
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField.text?.lengthOfBytes(using: .utf8) == 0 {
//            MBProgressHUD.showError("请输入文件名", to: self.view)
//            return false
//        }
        return true
    }
    @IBAction func startUploadVideoAction(_ sender: UIButton) {
        if inputTextField.text == "\n"{
            MBProgressHUD.showError("请输入文件名", to: self.view)
            inputTextField.resignFirstResponder()
            return
        }
        if inputTextField.text?.lengthOfBytes(using: .utf8) == 0 {
            MBProgressHUD.showError("请输入文件名", to: self.view)
            return
        }
        passVideoRequest()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func backAction(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func generateThumbImage(url : URL) -> UIImage?{
        
        let asset = AVAsset(url: url)
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMake(1, 30)
        let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        
        guard let cgImage = img else { return nil }
        
        let frameImg    = UIImage(cgImage: cgImage)
        return frameImg
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
