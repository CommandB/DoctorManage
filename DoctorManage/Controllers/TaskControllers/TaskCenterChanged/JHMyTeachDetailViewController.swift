//
//  JHMyTeachDetailViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/12/5.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class JHMyTeachDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    private var tableview:UITableView = UITableView()
    var enterPath:ENTER_PATH!
    var headInfo:NSDictionary!
    var dataSource:[NSDictionary] = []
    
    var qrcodeStr = ""
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "topBackgroundIcon"), for: .default)
        self.navigationController?.navigationBar.isTranslucent = false;
        self.extendedLayoutIncludesOpaqueBars = true;
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        tableview.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.frame.size.height)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableFooterView = UIView()
        self.view.addSubview(tableview)
        let nib1 = UINib(nibName: "BaseTableViewCell", bundle: nil)
        self.tableview.register(nib1, forCellReuseIdentifier: "BaseCell")
        let nib2 = UINib(nibName: "DescribleCell", bundle: nil)
        self.tableview.register(nib2, forCellReuseIdentifier: "DescribleCell")
        let nib3 = UINib(nibName: "PersonalHeadCell", bundle: nil)
        self.tableview.register(nib3, forCellReuseIdentifier: "PersonalHeadCell")
        let nib4 = UINib(nibName: "TaskPersonInfoCell", bundle: nil)
        self.tableview.register(nib4, forCellReuseIdentifier: "TaskPersonInfoCell")
        let nib5 = UINib(nibName: "SeeQuestionCell", bundle: nil)
        self.tableview.register(nib5, forCellReuseIdentifier: "SeeQuestionCell")
        
        let nib6 = UINib(nibName: "JHScanCodeViewCell", bundle: nil)
        self.tableview.register(nib6, forCellReuseIdentifier: "JHScanCodeViewCell")

        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(dismissAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "附件", style: .done, target: self, action: #selector(OtherFilesAction))
        getDetailData()
        requestQRCode()
        addTimer()
    }
    
    func addTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(reloadAction), userInfo: nil, repeats: true)
    }
    
    func reloadAction() {
        if self.qrcodeStr.isEmpty {
            return
        }
        self.requestQRCode()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    func requestQRCode() {
        let urlString = "http://"+Ip_port2+"doctor_train/rest/public/GenerateQRCode.do"
        guard let params = ["token":UserInfo.instance().token,"type":"pctask","taskid":headInfo["taskid"]] as? [String:String] else { return }
        
        Alamofire.request(urlString, method: .post, parameters: params).responseJSON { (response) in
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1" {
                    //                    if let url = URL.init(string: json["qrcode"].stringValue) {
                    //                        self.codeImageView.sd_setImage(with: url, placeholderImage: nil)
                    //                    }
                    self.qrcodeStr = json["qrcode"].stringValue
                    
                    let cell = self.tableview.cellForRow(at: IndexPath.init(row: 0, section: 1)) as! JHScanCodeViewCell
                    
                    cell.scanCodeView.image =                self.setupQRCodeImage(json["qrcode"].stringValue, image: nil)
                }else{
                    print("error")
                }
            }
        }
    }
    
    //MARK: -传进去字符串,生成二维码图片
    func setupQRCodeImage(_ text: String, image: UIImage?) -> UIImage {
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        //将url加入二维码
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        //取出生成的二维码（不清晰）
        if let outputImage = filter?.outputImage {
            //生成清晰度更好的二维码
            let qrCodeImage = setupHighDefinitionUIImage(outputImage, size: 300)
            
            return qrCodeImage
        }
        
        return UIImage()
    }
    
    //MARK: - 生成高清的UIImage
    func setupHighDefinitionUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion);
        bitmapRef.draw(bitmapImage, in: integral);
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
    
    func getDetailData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let params = ["pageindex":"0","pagesize": "10000","taskid":headInfo["taskid"],"token":UserInfo.instance().token]
        NetworkTool.sharedInstance.requestTaskDetail(params: params as! [String : String], success: { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = response["data"] {
                self.dataSource = data as! [NSDictionary]
                self.tableview.reloadData()
            }
        }) { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if enterPath == .UNCOMPLETE {
            return 4
        }
        else if enterPath == .TRAINING {
            //return 4  查看习题先不做
            return 4
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section <= 2 || section == 4{
            return 1
        }
        return dataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableview.dequeueReusableCell(withIdentifier: "BaseCell", for: indexPath) as! BaseTableViewCell
            cell.titleLabel.text = headInfo.stringValue(forKey: "title")
            //        cell.timeLabel.text = "(明天)"
            cell.timeLabel.isHidden = true
            //            if Int(headInfo.stringValue(forKey: "left_hour"))! < 0 {
            //                cell.retainTimeLabel.text = "0"
            //            }else{
            //                cell.retainTimeLabel.text = headInfo.stringValue(forKey: "left_hour")
            //            }
            cell.retainTimeLabel.text = headInfo.stringValue(forKey: "overhour")
            cell.beginTimeLabel.text = headInfo.stringValue(forKey: "starttime_show")
            cell.addressLabel.text = headInfo.stringValue(forKey: "addressname")
            cell.beginTimeLabel.text = headInfo.stringValue(forKey: "starttime_show")
            cell.beginTimeLabel.textColor = UIColor(red: 249/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
            cell.endTimeLabel.text = headInfo.stringValue(forKey: "endtime_show")
            cell.endTimeLabel.textColor = UIColor(red: 249/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
            cell.addressLabel.text = headInfo.stringValue(forKey: "addressname")
            tableView.separatorStyle = .singleLine
            return cell
        }else if indexPath.section == 1{
            let cell = tableview.dequeueReusableCell(withIdentifier: "JHScanCodeViewCell", for: indexPath) as! JHScanCodeViewCell
            return cell
        }
        else if indexPath.section == 2{
            let cell = tableview.dequeueReusableCell(withIdentifier: "DescribleCell", for: indexPath) as! DescribleCell
            cell.titleLabel.text = "课程描述"
            cell.contentLabel.text = headInfo.stringValue(forKey: "note")
            return cell
        }else if indexPath.section == 3{
            if indexPath.row == 0 {
                let cell = tableview.dequeueReusableCell(withIdentifier: "PersonalHeadCell", for: indexPath) as! PersonalHeadCell
                tableView.separatorStyle = .singleLine
                return cell
            }else{
                tableView.separatorStyle = .none
                let cell = tableview.dequeueReusableCell(withIdentifier: "TaskPersonInfoCell", for: indexPath) as! TaskPersonInfoCell
                if let personname = dataSource[indexPath.row-1].stringValue(forKey: "personname") {
                    cell.nameLabel.text = personname
                }else{
                    cell.nameLabel.text = "--"
                }
                
                cell.professionalLabel.text = dataSource[indexPath.row-1].stringValue(forKey: "professionaltitle")
                cell.lateLabel.text = dataSource[indexPath.row-1].stringValue(forKey: "signresultshow")
                return cell
            }
        }else{
            let cell = tableview.dequeueReusableCell(withIdentifier: "SeeQuestionCell", for: indexPath) as! SeeQuestionCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }else if indexPath.section == 1 {
            return 280
        }
        else if indexPath.section <= 2 {
            if let noteStr = headInfo.stringValue(forKey: "note") {
                return noteStr.getLabHeight(labelStr: noteStr, font: UIFont.systemFont(ofSize: 13), width: self.view.frame.size.width-35)+80
            }
            return 150
        }
        return 38
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func dismissAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 3 && indexPath.row > 0 {
            if headInfo["task_state"] as! NSNumber == 3 || headInfo["task_state"] as! NSNumber == 4{
                return
            }
            //            let cell = tableview.cellForRow(at: indexPath) as! TaskPersonInfoCell
            //            if !(cell.professionalLabel.text?.contains("医师"))! {
            showCheckAlert(indexPath: indexPath)
            //            }
        }else if indexPath.section == 4{
            self.navigationController?.pushViewController(QuestionViewController(), animated: true)
        }
    }
    // MARK: - check alert
    
    func showCheckAlert(indexPath:IndexPath) {
        let checkAlert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let lateAction = UIAlertAction.init(title: "迟到", style: UIAlertActionStyle.default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.requestRecordTaskSignResult(type: "迟到", indexPath: indexPath)
        })
        lateAction.setValue(UIColor.init(red: 59/255.0, green: 69/255.0, blue: 79/255.0, alpha: 1.0), forKey: "_titleTextColor")
        let truancyAction = UIAlertAction.init(title: "旷课", style: UIAlertActionStyle.default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.requestRecordTaskSignResult(type: "旷课", indexPath: indexPath)
        })
        truancyAction.setValue(UIColor.init(red: 59/255.0, green: 69/255.0, blue: 79/255.0, alpha: 1.0), forKey: "_titleTextColor")
        let okAction = UIAlertAction.init(title: "正常", style: UIAlertActionStyle.default, handler:{
            (alert: UIAlertAction!) -> Void in
            self.requestRecordTaskSignResult(type: "正常", indexPath: indexPath)
        })
        okAction.setValue(UIColor.init(red: 59/255.0, green: 69/255.0, blue: 79/255.0, alpha: 1.0), forKey: "_titleTextColor")
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        cancelAction.setValue(UIColor.init(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0), forKey: "_titleTextColor")
        checkAlert.addAction(lateAction)
        checkAlert.addAction(truancyAction)
        checkAlert.addAction(okAction)
        checkAlert.addAction(cancelAction)
        self.present(checkAlert, animated: true, completion: nil)
    }
    
    func requestRecordTaskSignResult(type:String,indexPath:IndexPath) {
        let params = ["taskid":headInfo["taskid"],"personid": dataSource[indexPath.row-1].stringValue(forKey: "personid"),"sign":type,"token":UserInfo.instance().token]
        let cell = tableview.cellForRow(at: indexPath) as! TaskPersonInfoCell
        cell.lateLabel.text = type
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkTool.sharedInstance.requestRecordTaskSignResult(params: params as! [String : String], success: { (response) in
            //            if let data = response["data"] {
            //                self.getDetailData()
            //            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @objc func OtherFilesAction() {
        let taskCenterStoryboard = UIStoryboard.init(name: "TaskCenter", bundle: nil)
        let vc = taskCenterStoryboard.instantiateViewController(withIdentifier: "OtherFilesController") as! JHOtherFilesController
        if let taskId = headInfo["taskid"] as? String{
            vc.taskId = taskId
            self.present(vc, animated: true, completion: nil)
        }
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
