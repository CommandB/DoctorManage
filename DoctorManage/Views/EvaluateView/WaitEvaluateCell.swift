//
//  WaitEvaluateCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/10/25.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class WaitEvaluateCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var accessView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var waitTypeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
