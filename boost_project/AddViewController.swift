//
//  AddViewController.swift
//  boost_project
//
//  Created by Byoung-Hwi Yoon on 2020/08/07.
//  Copyright © 2020 남기범. All rights reserved.
//

import UIKit

// 매물 추가화면 뷰 컨트롤러

class AddViewController: UIViewController {

    
    @IBOutlet var tf_address: UITextField!
    
    @IBOutlet var sgc_type: UISegmentedControl!
    
    @IBOutlet var tf_deposit: UITextField!
    
    @IBOutlet var tf_monthlyPrice: UITextField!
    
    @IBOutlet var tf_managementFee: UITextField!
    
    @IBOutlet var tf_area: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnCommit(_ sender: UIBarButtonItem) {
        
        let item = RealEstateItem()
        
        item.address = tf_address.text ?? ""
        item.depositPrice = Int(tf_deposit.text ?? "0") ?? 0
        item.monthlyPrice = Int(tf_monthlyPrice.text ?? "0") ?? 0
        item.managementFee = Int(tf_managementFee.text ?? "0") ?? 0
        item.area = Int(tf_area.text ?? "0") ?? 0
        
        switch sgc_type.selectedSegmentIndex {
            
        case 0 :
            item.type = "전세"
        case 1 :
            item.type = "월세"
        case 2 :
            item.type = "매매"
        default :
            item.type = ""
        }
        
        let db = DBManager.getInstance()
        let insertedId = db.insertRealEstateItem(item: item)
        
        let keywords = APIManager.getKeywords(from: item.address)
        
        for keyword in keywords{
            db.insertKeyword(iid: insertedId, keyword: keyword)
        }
        
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
