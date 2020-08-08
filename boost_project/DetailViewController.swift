//
//  DetailViewController.swift
//  boost_project
//
//  Created by Byoung-Hwi Yoon on 2020/08/08.
//  Copyright © 2020 남기범. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var item : RealEstateItem = RealEstateItem()
    
    @IBOutlet var lbl_Address: UILabel!
    
    @IBOutlet var lbl_Type: UILabel!
    
    @IBOutlet var lbl_Price: UILabel!
    
    @IBOutlet var lbl_Area: UILabel!
    
    @IBOutlet var lbl_ManagementFee: UILabel!
    
    @IBOutlet var lbl_Struct: UILabel!
    
    
    override func viewDidLoad() {
        NSLog("상세뷰 켜짐")
        super.viewDidLoad()
        
        lbl_Address.text = item.address
        
        lbl_Type.text = item.type
        
        lbl_Area.text = "\(item.area) ㎡"
        
        lbl_ManagementFee.text = "\(item.managementFee) 만원"
        
        lbl_Struct.text = item.structType
        
        if item.monthlyPrice == 0 {
            lbl_Price.text = "\(item.depositPrice)"
        } else {
            lbl_Price.text = "\(item.depositPrice) / \(item.monthlyPrice)"
        }
        
        
        //임시
        if item.type == "전세" {
            lbl_Struct.text = "투룸"
        } else {
            lbl_Struct.text = "분리형 원룸"
        }

        // Do any additional setup after loading the view.
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
