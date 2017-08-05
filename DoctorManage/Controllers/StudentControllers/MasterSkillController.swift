//
//  MasterSkillController.swift
//  jiaoshi3
//
//  Created by chenhaifeng  on 2017/6/9.
//  Copyright © 2017年 chenhaifeng . All rights reserved.
//

import UIKit

class MasterSkillController: UITableViewController {
    var receiveDataList:[NSDictionary] = []
    var completenum:String = ""
    var titleNum:String = ""
    var ratioNum:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "topBack.png"), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(dismissAction))
        let nib = UINib(nibName: "MasterSkillCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "MasterSkillCell")
        self.tableView.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiveDataList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterSkillCell", for: indexPath) as! MasterSkillCell
        cell.titleLabel?.text = receiveDataList[indexPath.row].stringValue(forKey: "requiredname")
        cell.ratioLabel.text = receiveDataList[indexPath.row].stringValue(forKey: "completenum")+"/"+receiveDataList[indexPath.row].stringValue(forKey: "requirednum")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
 
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.tintColor = UIColor(red: 214.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1.0)
        self.setSectionHeader(view: view, section: section)

    }

    func setSectionHeader(view:UIView ,section:Int){
        let leftLabel = UILabel()
        let rightLabel = UILabel()
        view.addSubview(leftLabel)
        view.addSubview(rightLabel)
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint.init(item: leftLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 15))
        view.addConstraint(NSLayoutConstraint.init(item: leftLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: rightLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -15))
        view.addConstraint(NSLayoutConstraint.init(item: rightLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))

        let leftStr = NSMutableAttributedString(string:"要求数例")
        //设置字体颜色
        leftStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 155/255.0, green: 166/255.0, blue: 174/255.0, alpha: 1.0),
                                     range: NSMakeRange(0, leftStr.length))
        //设置文字背景颜色
        let titleNumStr = NSMutableAttributedString(string:titleNum)
        titleNumStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 249/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0),
                                              range: NSMakeRange(0,titleNumStr.length))
        leftStr.insert(titleNumStr, at: 3)
        leftLabel.attributedText = leftStr
        
        let rightStr = NSMutableAttributedString(string:"达成例")
        rightStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 155/255.0, green: 166/255.0, blue: 174/255.0, alpha: 1.0),
                              range: NSMakeRange(0, rightStr.length))
        let numStr = NSMutableAttributedString(string: completenum)
        numStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 98/255.0, green: 166/255.0, blue: 233/255.0, alpha: 1.0),
                            range: NSMakeRange(0, numStr.length))
        rightStr.insert(numStr, at: 2)
        let ratioStr = NSMutableAttributedString(string: ratioNum)
        ratioStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 98/255.0, green: 166/255.0, blue: 233/255.0, alpha: 1.0),
                            range: NSMakeRange(0, ratioStr.length))
        rightStr.append(ratioStr)
        rightLabel.attributedText = rightStr
    }

    func dismissAction() {
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
