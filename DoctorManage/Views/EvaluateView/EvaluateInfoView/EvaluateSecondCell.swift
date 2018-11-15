//
//  EvaluateSecondCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/22.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
protocol EvaluateSecondCellDelegate: class {
    func updateModelDataDelegate(yellowStarNum: Int,cell:EvaluateSecondCell)
}

class EvaluateSecondCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomLine: UILabel!
    var yellowStarNum = 5
    weak var delegate: EvaluateSecondCellDelegate?

    @IBAction func tapStarAction(_ sender: UIButton) {
        for viewtag in sender.tag...105 {
            if let view = self.viewWithTag(viewtag) {
                (view as! UIButton).setImage(UIImage.init(named: "空星"), for: .normal)
            }
        }
        for viewtag in 101...sender.tag {
            if let view = self.viewWithTag(viewtag) {
                (view as! UIButton).setImage(UIImage.init(named: "满星"), for: .normal)
            }
        }
        yellowStarNum = sender.tag-100
        self.delegate?.updateModelDataDelegate(yellowStarNum: yellowStarNum,cell:self)
    }
    
    func setYellowStarNum(num:Int) {
        if num == 5 {
            for index in 1...5 {
                if let view = self.viewWithTag(index+100) {
                    (view as! UIButton).setImage(UIImage.init(named: "满星"), for: .normal)
                }
            }
            return
        }
        for index in 1...5 {
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
    override func layoutSubviews() {

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
