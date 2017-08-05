//
//  HistoryEvaluateCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/20.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class HistoryEvaluateCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var enterIconView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
