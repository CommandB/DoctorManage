//
//  SubResMineController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/17.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
class SubResMineController: UIViewController,UITableViewDataSource,UITableViewDelegate,subResMineCellDelegate,UIScrollViewDelegate,UIDocumentInteractionControllerDelegate {
    var tableview = UITableView()
    var player:XLVideoPlayer!
    var dataSource:[JSON] = []
    var index = 0
    var thumbnailArr = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview = UITableView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.bounds.size.height-90))
        self.view.addSubview(tableview)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        let nib1 = UINib(nibName: "subResMineCell", bundle: nil)
        self.tableview.register(nib1, forCellReuseIdentifier: "subResMineCell")
        self.tableview.separatorStyle = .none
        self.tableview.backgroundColor = UIColor.init(red: 245/255.0, green: 248/255.0, blue: 251, alpha: 1.0)
        self.tableview.tableFooterView = UIView()
        self.tableview.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        self.tableview.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
        self.tableview.mj_footer.isAutomaticallyChangeAlpha = true
        self.tableview.mj_header.beginRefreshing()
        NotificationCenter.default.addObserver(self, selector: #selector(uploadSuccess(_:)), name:NSNotification.Name(rawValue: kUploadVideoSuccessNotification), object: nil)
    }
    
    func requestResMineData(pageindex:Int) {
        let urlString = "http://"+Ip_port2+"doctor_train/rest/teachingMaterial/queryMine.do"
        let params = ["token":UserInfo.instance().token,"gettype":"1","pageindex":String(pageindex*10),"pagesize": "10"] as! [String:String]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(urlString, method: .post, parameters: params).responseJSON { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableview.mj_header.endRefreshing()
            self.tableview.mj_footer.endRefreshing()
            MBProgressHUD.hide(for:  self.view, animated: true)
            switch(response.result){
            case .failure(let error):
                print(error)
            case .success(let response):
                let json = JSON(response)
                if json["code"].stringValue == "1"{
                    //                    self.dataSource = json["data"].arrayValue
                    for item in json["data"].arrayValue{
                        self.dataSource.append(item)
                    }
//                    self.createImages()
                    self.tableview.reloadData()
                    if json["data"].arrayValue.count == 0{
                        self.tableview.mj_footer.endRefreshingWithNoMoreData()
                    }
                }else{
                    print("error")
                }
            }
        }
    }
    
    func refreshAction() {
        dataSource.removeAll()
        thumbnailArr.removeAll()
        index = 0
        self.tableview.mj_footer.resetNoMoreData()
        requestResMineData(pageindex: index)
    }
    
    func loadMoreAction() {
        index = index + 1
        requestResMineData(pageindex: index)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = subResMineCell.videoCellWithTableView(tableview: tableView)
        if let imageUrlStr = self.dataSource[indexPath.section]["imageUrl"] as? String,let url = URL.init(string: imageUrlStr) {
            cell.videoImageView.sd_setImage(with: url)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showVideoPlayer(gesture:)))
        cell.videoImageView.addGestureRecognizer(tap)
        cell.titleLabel.text = self.dataSource[indexPath.section]["title"].stringValue
        cell.nameLabel.text = self.dataSource[indexPath.section]["speaker"].stringValue
        cell.timeLabel.text = self.dataSource[indexPath.section]["createtime"].stringValue
        cell.delegate = self
        cell.selectionStyle = .none
        cell.videoImageView.tag = 100 + indexPath.section
        return cell
    }
    
    func showVideoPlayer(gesture:UITapGestureRecognizer) {
        if player != nil {
            player.destroy()
        }
        let view = gesture.view
        
        let indexPath = IndexPath.init(row: 0, section: (view?.tag)!-100)
        let cell = tableview.cellForRow(at: indexPath) as! subResMineCell
        
        if dataSource[indexPath.section]["type"].intValue != 0{
            downloadFile(indexpath: indexPath)
            return
        }
        
        player = XLVideoPlayer()
        player.videoUrl = dataSource[indexPath.section]["fullurl"].stringValue
        //        "http://v1.mukewang.com/57de8272-38a2-4cae-b734-ac55ab528aa8/L.mp4"
        player.playerBindTableView(tableview, currentIndexPath: indexPath)
        player.frame = (view?.bounds)!
        
        cell.videoImageView.addSubview(player)
        player.completedPlayingBlock = {(player) -> (Void) in
            player?.destroy()
            //            player?.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        for cell in tableView.visibleCells {
        //            (cell as! subResMineCell).avPlayer.player?.pause()
        //        }
        //        let cell = tableView.cellForRow(at: indexPath) as! subResMineCell
        //        cell.avPlayer.player?.play()
    }
    
    func shareBtnDelegate(button:UIButton){
        let customView = BRCustomOptionView.init(frame: self.view.frame)
        self.view.addSubview(customView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 25))
        label.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        return label
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(self.tableview) {
            if player != nil {
                player.playerScrollIsSupportSmallWindowPlay(false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if player != nil {
            player.destroy()
        }
    }
    
    func createImages() {
        for item in self.dataSource{
            if let url = URL.init(string: item["fullurl"].stringValue){
                let image = self.generateThumbImage(url:url) ?? UIImage.init(named: "testresource")
                self.thumbnailArr.append(image!)
            }else{
                self.thumbnailArr.append(UIImage.init(named: "testresource")!)
            }
        }
        self.tableview.reloadData()
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
    
    func uploadSuccess(_ notification:Notification)
    {
        self.tableview.mj_header.beginRefreshing()
    }
    
    func downloadFile(indexpath:IndexPath) {
        //指定下载路径和保存文件名
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(self.dataSource[indexpath.section]["reffilename"].stringValue)
            print("\r\r测试--------------文件保存---------------\r\r")
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        //开始下载
        Alamofire.download(self.dataSource[indexpath.section]["fullurl"].stringValue, to: destination)
            .response { response in
                //print(response)
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent(self.dataSource[indexpath.section]["reffilename"].stringValue)
                self.openFile(fileURL)
                
        }
    }
    
    
    func openFile(_ filePath: URL) {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        let _docController = UIDocumentInteractionController.init(url: filePath)
        _docController.delegate = self        
        _docController.presentPreview(animated: true)
    }
    
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    
    func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
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
