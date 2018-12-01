//
//  CheckQRCodeController.swift
//  DoctorManage
//
//  Created by chenhaifeng on 2018/10/8.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CheckQRCodeController: JHBaseViewController {
    var taskid = ""
    var detailDic = NSDictionary()
    var qrcodeStr = ""
    var timer:Timer?
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var codeImageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "任务明细"
        setNavBackItem(true)
        configUI()
        requestQRCode()
        addTimer()
    }

    func configUI() {
        titleLabel.text = detailDic["title"] as? String
        beginTimeLabel.text = detailDic["starttime"] as? String
        endTimeLabel.text = detailDic["endtime"] as? String
        addressLabel.text = detailDic["addressname"] as? String
    }
    
    func addTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(reloadAction), userInfo: nil, repeats: true)
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
        let params = ["token":UserInfo.instance().token,"type":"pctask","taskid":taskid] as! [String:String]
        
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
                    self.codeImageView.image =                self.setupQRCodeImage(json["qrcode"].stringValue, image: nil)
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
    
//    func createQrCode(informationString:String)  {
//        let filter = CIFilter(name: "CIQRCodeGenerator")
//        filter?.setDefaults()
//        let data = informationString.data(using: .utf8)
//        filter?.setValue(data, forKey: "inputMessage")
//
//        let outputImage = filter?.outputImage
//        self.sharpenQrCodeIamge(image: outputImage!)
//    }
//
//    //清晰化生成的二维码
//    func sharpenQrCodeIamge(image:CIImage) {
//        let scaleX = self.codeImageView.frame.size.width/image.extent.size.width
//        let scaleY = self.codeImageView.frame.size.height/image.extent.size.height
//        image = image.imageByApplyingTransform
//        self.codeImageView.image  = UIImage(ciImage: image, scale: UIScreen.main.scale, orientation: .up)
//    }
    
    
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
