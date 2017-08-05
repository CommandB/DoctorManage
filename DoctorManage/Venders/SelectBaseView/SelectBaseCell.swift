//
//  SelectBaseCell.swift
//  DoctorManage
//
//  Created by chenhaifeng  on 2017/6/28.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit

class SelectBaseCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectImage.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
