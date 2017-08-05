//
//  WishlistCell.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/8.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
protocol WishlistCellDelegate: class {
    func addWishList(_ sender: UIButton)
}
class WishlistCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate: WishlistCellDelegate?

    @IBAction func checkBtnTapped(_ sender: UIButton) {
//        if sender.isSelected {
//            sender.setBackgroundImage(UIImage.init(named: "未勾选"), for: .normal)
//            sender.isSelected = false
//        }else{
//            sender.setBackgroundImage(UIImage.init(named: "勾选"), for: .normal)
//            sender.isSelected = true
//        }
        delegate?.addWishList(sender)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
