//
//  ApplyTaskCell.swift
//  DoctorManage
//
//  Created by chenhaifeng  on 2017/7/18.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
protocol ApplyTaskCellDelegate: class {
    func editTextDoneTapped(imageArr: [String],index:Int)
}

class ApplyTaskCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var illLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    
    weak var delegate: ApplyTaskCellDelegate?
    var item = [JSON]()

    
    
    @IBAction func imageBtnTapped(_ sender: UIButton) {
        var images = [String]()
        for listinfo in self.item {
            images.append(listinfo["url"].stringValue)
        }
//        let images = self.item.object(forKey: "images")
        self.delegate?.editTextDoneTapped(imageArr: images, index: sender.tag-2001)
    }
    
    func setObject(aObj:[JSON]) {
        self.item = aObj
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.item.count == 0 {
            return
        }
        for i in 0...self.item.count-1 {
            let urlStr = self.item[i]["url"].stringValue
            let pictureBtn = self.viewWithTag(i+2001) as! UIButton
            pictureBtn.isHidden = false
            pictureBtn.sd_setBackgroundImage(with: URL.init(string: urlStr), for: .normal, placeholderImage: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
