//
//  EvaluateCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/10.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class EvaluateCell: UITableViewCell {
    var yellowStarNum = 0
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var goodRatio: UILabel!
    @IBAction func tapStarAction(_ sender: UIButton) {
//        for viewtag in sender.tag...105 {
//            if let view = self.viewWithTag(viewtag) {
//                (view as! UIButton).setImage(UIImage.init(named: "空星"), for: .normal)
//            }
//        }
//        for viewtag in 101...sender.tag {
//            if let view = self.viewWithTag(viewtag) {
//                (view as! UIButton).setImage(UIImage.init(named: "满星"), for: .normal)
//            }
//        }
//        yellowStarNum = sender.tag-100
    }
    
    func setYellowStarNum(num:Int) {
        for index in 1...num {
            if let view = self.viewWithTag(index+100) {
                (view as! UIButton).setImage(UIImage.init(named: "空星"), for: .normal)
            }
        }
        for index in 1...num {
            if let view = self.viewWithTag(index+100) {
                (view as! UIButton).setImage(UIImage.init(named: "满星"), for: .normal)
            }
        }
        yellowStarNum = num
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
