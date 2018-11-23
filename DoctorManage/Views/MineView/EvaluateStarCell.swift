//
//  EvaluateStarCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/7/15.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class EvaluateStarCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomLine: UILabel!
    var yellowStarNum = 0
    
    func setYellowStarNum(num:Int, allStars:Int) {
        for index in 1...5 {
            if let view = self.viewWithTag(index+100) {
                (view as! UIButton).setImage(UIImage.init(named: "空星"), for: .normal)
                (view as! UIButton).isHidden = false
            }
        }
        if num == 0 {
            return
        }
        for index in 1...5 {
            if let view = self.viewWithTag(index+100) {
                (view as! UIButton).setImage(UIImage.init(named: "空星"), for: .normal)
                if index > allStars {
                    (view as! UIButton).isHidden = true
                }else{
                    (view as! UIButton).isHidden = false
                }
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
