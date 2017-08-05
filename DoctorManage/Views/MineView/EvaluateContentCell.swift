//
//  EvaluateContentCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/7/3.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class EvaluateContentCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var getScore: UILabel!
    @IBOutlet weak var favRatio: UILabel!
    @IBOutlet weak var bottomLine: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
