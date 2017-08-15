//
//  InfoHeadCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/15.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
protocol InfoHeadCellDelegate: class {
    func photoBtnTapped(photoBtn: UIButton)
}
class InfoHeadCell: UITableViewCell {
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var officeName: UILabel!
    @IBOutlet weak var jobNum: UILabel!
    @IBOutlet weak var highestDegree: UILabel!
    @IBOutlet weak var photoBtn: UIButton!
    weak var delegate: InfoHeadCellDelegate?

    @IBAction func touchPhotoBtn(_ sender: UIButton) {
        self.delegate?.photoBtnTapped(photoBtn: sender)
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
