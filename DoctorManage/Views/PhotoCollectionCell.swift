//
//  PhotoCollectionCell.swift
//  jiaoshi3
//
//  Created by chenhaifeng  on 2017/6/9.
//  Copyright © 2017年 chenhaifeng . All rights reserved.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {
    @IBOutlet weak var backgroundview: UIView!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var triangleView: UIImageView!
    @IBOutlet weak var moreView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        triangleView.image = triangleImageWithSize(size: CGSize.init(width: 20, height: 10), tintColor: UIColor.init(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0))
        triangleView.isHidden = true
        moreView.isHidden = true
    }
    
    func triangleImageWithSize(size:CGSize,tintColor:UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        let ctx = UIGraphicsGetCurrentContext()
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: 0, y: size.height))
        path.addLine(to: CGPoint.init(x: size.width/2, y: 0))
        path.addLine(to: CGPoint.init(x: size.width, y: size.height))
        path.close()
        ctx!.setFillColor(tintColor.cgColor);
        path.fill()
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
    }
    
    override func draw(_ rect: CGRect) {
        photoImage.layer.cornerRadius = photoImage.bounds.size.width/2
        photoImage.layer.masksToBounds = true
    }
}
