//
//  QuestionViewController.swift
//  jiaoshi4
//
//  Created by chenhaifeng  on 2017/6/13.
//  Copyright © 2017年 chenhaifeng . All rights reserved.
//

import UIKit

class QuestionViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "习题"
        let image = UIImage(named: "返回")!.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:image, style: .done, target: self, action: #selector(backAction))
        let nib = UINib(nibName: "QuestionSelectCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "QuestionSelectCell")
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "QuestionCell")
    }
    func backAction() {
        self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            cell.contentLabel?.text = "能马路看到你们啦看美女的莱卡棉男的来看鸣锣"
//        }else{
//            cell.contentLabel?.text = "男的来看鸣锣开道大家好大家阿萨德那绝"
//        }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
            
            let titleStr = NSMutableAttributedString(string:"1.能马路看到你们啦看美女的莱卡棉男的来看鸣锣能马路看到你们啦看美女的莱卡棉男的来看鸣锣")
            titleStr.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 59/255.0, green: 69/255.0, blue: 79/255.0, alpha: 1.0),
                                 range: NSMakeRange(0, titleStr.length))
            
            let errorRatioStr = NSMutableAttributedString(string: " "+"(错误率80%)")
            errorRatioStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 249/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0),
                                  range: NSMakeRange(0, errorRatioStr.length))
            titleStr.append(errorRatioStr)
            
            cell.textLabel?.attributedText = titleStr
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            tableView.separatorStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionSelectCell", for: indexPath) as! QuestionSelectCell

            if indexPath.row == 1 {
                cell.optionLabel.text = "A"
                cell.optionLabel.backgroundColor = UIColor(red: 184/255.0, green: 233/255.0, blue: 134/255.0, alpha: 1.0)
                cell.optionLabel.textColor = .white
                cell.contentLabel.textColor = UIColor(red: 160/255.0, green: 212/255.0, blue: 124/255.0, alpha: 1.0)
                cell.contentLabel?.text = "男的来看鸣锣开道大家好大家阿萨德那绝"
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                return cell
            }else{
                if indexPath.row == 2{
                    cell.optionLabel.text = "B"
                    cell.optionLabel.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
                    cell.optionLabel.textColor = UIColor(red: 94/255.0, green: 163/255.0, blue: 243/255.0, alpha: 1.0)
                    cell.contentLabel.textColor = UIColor(red: 155/255.0, green: 166/255.0, blue: 174/255.0, alpha: 1.0)
                    cell.contentLabel?.text = "男的来看鸣锣开道大家好大家阿萨德那绝"
                }else if indexPath.row == 3 {
                    cell.optionLabel.text = "C"
                    cell.optionLabel.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
                    cell.optionLabel.textColor = UIColor(red: 94/255.0, green: 163/255.0, blue: 243/255.0, alpha: 1.0)
                    cell.contentLabel.textColor = UIColor(red: 155/255.0, green: 166/255.0, blue: 174/255.0, alpha: 1.0)
                    cell.contentLabel?.text = "男的来看鸣锣开道大家好大家阿萨德那绝"
                }else{
                    cell.optionLabel.text = "D"
                    cell.optionLabel.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
                    cell.optionLabel.textColor = UIColor(red: 94/255.0, green: 163/255.0, blue: 243/255.0, alpha: 1.0)
                    cell.contentLabel.textColor = UIColor(red: 155/255.0, green: 166/255.0, blue: 174/255.0, alpha: 1.0)
                    cell.contentLabel?.text = "男的来看鸣锣开道大家好大家阿萨德那绝"
                }
                cell.selectionStyle = .none
                tableView.separatorStyle = .none
                return cell
            }
        }
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
//            let cell = tableView.cellForRow(at: indexPath)
            return computeStringLengthWithString("1.能马路看到你们啦看美女的莱卡棉男的来看鸣锣能马路看到你们啦看美女的莱卡棉男的来看鸣锣", fontSize: 15.0)
        }
        return computeStringLengthWithString("1.能马路看到你们啦看美女的莱", fontSize: 15)
    }
    
    func computeStringLengthWithString(_ string:String,fontSize:CGFloat) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let dic = [NSFontAttributeName:UIFont.systemFont(ofSize: fontSize),NSParagraphStyleAttributeName:paragraphStyle]
        
        let height = NSString.init(string: string).boundingRect(with: CGSize.init(width: self.view.bounds.size.width-60, height: 1000), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: dic, context: nil).size.height
        return height+20
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let cell = tableView.cellForRow(at: indexPath) as! QuestionSelectCell
//        if cell.optionLabel.backgroundColor == .red {
//            cell.optionLabel.backgroundColor = UIColor(red: 245/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
//            cell.optionLabel.textColor = UIColor(red: 94/255.0, green: 163/255.0, blue: 243/255.0, alpha: 1.0)
//        }else{
//            cell.optionLabel.backgroundColor = UIColor(red: 184/255.0, green: 233/255.0, blue: 134/255.0, alpha: 1.0)
//            cell.optionLabel.textColor = .white
//        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
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
