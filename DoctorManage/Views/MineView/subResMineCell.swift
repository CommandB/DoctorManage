//
//  subResMineCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/15.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

protocol subResMineCellDelegate:class {
    func shareBtnDelegate(button:UIButton)
}

class subResMineCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var videoImageView: UIImageView!
    weak var delegate:subResMineCellDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    
    var avPlayer = AVPlayerViewController()
    override func awakeFromNib() {
        super.awakeFromNib()
        videoImageView.isUserInteractionEnabled = true
//        addVideo()
    }

    class func videoCellWithTableView(tableview:UITableView) -> subResMineCell{
        let ID = "subResMineCell"
        var cell = tableview.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = Bundle.main.loadNibNamed("subResMineCell", owner: nil, options: nil)?.last as? subResMineCell
            cell?.selectionStyle = .none
        }
        return cell as! subResMineCell
    }
    

    func addVideo() {
    avPlayer.view.frame = CGRect.init(x: 0, y: 0, width: videoImageView.frame.size.width, height: videoImageView.frame.size.height)
    videoImageView.addSubview(avPlayer.view)
    videoImageView.isUserInteractionEnabled = true
            let videoURL = URL.init(string: "http://v1.mukewang.com/57de8272-38a2-4cae-b734-ac55ab528aa8/L.mp4")
    //        avPlayer.player = AVPlayer.init(url: videoURL!)
    
//    let filePath = Bundle.main.path(forResource: "Change Toner.mp4", ofType: nil)
    
//    let videoURL = URL.init(fileURLWithPath: filePath!)
    
    avPlayer.player = AVPlayer.init(url: videoURL!)
    avPlayer.videoGravity = AVLayerVideoGravityResizeAspect
    }
    
    @IBAction func shareBtntapped(_ sender: Any) {
        self.delegate?.shareBtnDelegate(button: sender as! UIButton)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
