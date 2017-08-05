//
//  CheckWorkCell.swift
//  jiaoshi3
//
//  Created by chenhaifeng  on 2017/6/9.
//  Copyright © 2017年 chenhaifeng . All rights reserved.
//

import UIKit
protocol CheckWorkCellDelegate: class {
    func absentBtnDidTapped(title: String,sender:UIButton)
}
class CheckWorkCell: UITableViewCell {
    weak var delegate: CheckWorkCellDelegate?

    @IBOutlet weak var attendRatio: UILabel!
    @IBOutlet weak var absent: UILabel!
    @IBOutlet weak var absentBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        absentBtn.layer.cornerRadius = absentBtn.frame.size.height/2
        absentBtn.layer.masksToBounds = true
        // Initialization code
    }

    @IBAction func didAbsentBtnTapped(_ sender: UIButton) {
        self.delegate?.absentBtnDidTapped(title: sender.title(for: .normal)!, sender: sender)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
