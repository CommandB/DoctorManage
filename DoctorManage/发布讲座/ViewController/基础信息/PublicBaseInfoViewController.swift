//
//  PublicBaseInfoViewController.swift
//  DoctorManage
//
//  Created by 陈海峰 on 2018/11/20.
//  Copyright © 2018年 chenshengchang. All rights reserved.
//

import UIKit

class PublicBaseInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = RGBCOLOR(r: 239, 239, 239)
        addChildViews()
    }

    func addChildViews() {
        tableView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: kScreenH-64-50)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = RGBCOLOR(r: 239, 239, 239)
        tableView.separatorStyle = .none
        
        self.view.addSubview(tableView)
        
        tableView.register(PublicInfoFirstCell.classForCoder(), forCellReuseIdentifier: "PublicInfoFirstCell")
        tableView.register(PublicInfoSecondCell.classForCoder(), forCellReuseIdentifier: "PublicInfoSecondCell")
        tableView.register(PublicInfoThirdCell.classForCoder(), forCellReuseIdentifier: "PublicInfoThirdCell")
        tableView.register(PublicInfoFourthCell.classForCoder(), forCellReuseIdentifier: "PublicInfoFourthCell")
        tableView.register(PublicInfoFiveCell.classForCoder(), forCellReuseIdentifier: "PublicInfoFiveCell")

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else if section == 2 {
            return 3
        }else if section == 3 {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublicInfoFirstCell", for: indexPath) as! PublicInfoFirstCell
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublicInfoSecondCell", for: indexPath) as! PublicInfoSecondCell
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublicInfoThirdCell", for: indexPath) as! PublicInfoThirdCell
            cell.setData(indexpath: indexPath)
            return cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublicInfoFourthCell", for: indexPath) as! PublicInfoFourthCell
            return cell
        }else if indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublicInfoFiveCell", for: indexPath) as! PublicInfoFiveCell
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                let selectAddressView = SelectAddressViewController()
                selectAddressView.cellClickCallBack = { (nameStr) in
                    if let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 2)) as? PublicInfoThirdCell {
                        cell.detailLabel.text = nameStr
                    }
                }
                self.present(UINavigationController(rootViewController: selectAddressView), animated: true)
                
            }else if indexPath.row == 1 {
                let selectTeacherView = SelectTeacherViewController()
                selectTeacherView.cellClickCallBack = { (nameStr) in
                    if let cell = tableView.cellForRow(at: IndexPath.init(row: 1, section: 2)) as? PublicInfoThirdCell {
                        cell.detailLabel.text = nameStr
                    }
                }
                self.present(UINavigationController(rootViewController: selectTeacherView), animated: true)
            }
           
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }else if indexPath.section == 1 {
            return 100
        }else if indexPath.section == 2 {
            return 44
        }else if indexPath.section == 3 {
            return 44
        }
        return 44*3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
