//
//  SelectBaseView.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2017/6/28.
//  Copyright © 2017年 chenshengchang. All rights reserved.
//

import UIKit
protocol SelectBaseViewDelegate:NSObjectProtocol{
    func didSelectBase(text:String)
}
class SelectBaseView: UIView,UITableViewDelegate,UITableViewDataSource {
    var tableView = UITableView()
    
//    @IBOutlet weak var tableView: UITableView!
    var contentView:UIView!
//    @IBOutlet weak var heightConstrain: NSLayoutConstraint!
    var delegate:SelectBaseViewDelegate!
    var dataSource:[NSDictionary] = [NSDictionary]()
    
    
    //初始化时将xib中的view添加进来
    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView = loadViewFromNib()
//        addSubview(contentView)
//        addConstraints()
//        self.backgroundColor = .gray
//        self.alpha = 0.5
        self.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5)
        self.addTableView()
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        contentView = loadViewFromNib()
        //        addSubview(contentView)
        //        addConstraints()
        //初始化属性配置
        //        initialSetup()
    }
    
    //加载xib
    func loadViewFromNib() -> UIView {
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    func addConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        var constraint = NSLayoutConstraint(item: contentView, attribute: .leading,
                                            relatedBy: .equal, toItem: self, attribute: .leading,
                                            multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: .trailing,
                                        relatedBy: .equal, toItem: self, attribute: .trailing,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal,
                                        toItem: self, attribute: .top, multiplier: 1, constant: 0)
        addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: .bottom,
                                        relatedBy: .equal, toItem: self, attribute: .bottom,
                                        multiplier: 1, constant: 0)
        addConstraint(constraint)
    }
    
    func addTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        self.addConstraint(NSLayoutConstraint.init(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: tableView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: tableView, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .width, multiplier: 1, constant: -100))
//        self.addConstraint(NSLayoutConstraint.init(item: tableView, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat((dataSource.count+1)*44)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        tableView.layer.cornerRadius = 5.0
        tableView.layer.masksToBounds = true
        let nib = UINib.init(nibName: "SelectBaseCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SelectBaseCell")
    }
    
    func reloadConstrains() {
        self.addConstraint(NSLayoutConstraint.init(item: tableView, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat((dataSource.count+1)*60)))
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectBaseCell") as! SelectBaseCell
//        if cell == nil {
//            cell = Bundle.main.loadNibNamed("SelectBaseCell", owner: nil, options: [:])?.first as? SelectBaseCell
//        }
        if indexPath.row == 0 {
            cell.titleLabel?.text = "选择基地"
            cell.titleLabel?.textAlignment = .center
            cell.isUserInteractionEnabled = false
        }else{
            cell.titleLabel?.text = dataSource[indexPath.row-1].object(forKey: "name") as? String
            cell.titleLabel?.textAlignment = .left
            cell.isUserInteractionEnabled = true
        }
        if cell.titleLabel.text == (self.delegate as! LoginViewController).selectBaseBtn.titleLabel?.text {
            cell.selectImage.isHidden = false
        }else{
            cell.selectImage.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 2.0, animations: { 
            
        }) { (bool) in
            self.removeFromSuperview()
        }
        let cell = tableView.cellForRow(at: indexPath) as! SelectBaseCell
        cell.selectImage.isHidden = false
        self.delegate.didSelectBase(text: cell.titleLabel.text!)
        UserDefaults.standard.set(dataSource[indexPath.row-1].object(forKey: "portalurl"), forKey: "portalurl")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
