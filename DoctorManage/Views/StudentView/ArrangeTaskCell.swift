//
//  ArrangeTaskCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/7/22.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class ArrangeTaskCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var sexlabel: UILabel!
    @IBOutlet weak var seniorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
