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
    @IBOutlet weak var realImageView: UIImageView!
    
    @IBOutlet weak var optionsLabel: UILabel!
    
    override func viewDidLoad() {
        NSLog("상세뷰 켜짐")
        super.viewDidLoad()
        
        lbl_Address.text = "주소: \(item.address)"
        
        lbl_Type.text = item.type
        
        lbl_Area.text = "\(item.area) ㎡"
        
        lbl_ManagementFee.text = "\(item.managementFee) 만원"
        
        lbl_Struct.text = item.structType

        realImageView.image = UIImage.load(item.imageName)
        
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
        
        let furnitureList = FurnitureOptions.makeArray(options: FurnitureOptions.init(rawValue: item.furnitureOptions))
        optionsLabel.text = furnitureList.map{ "#\($0)" }.joined(separator: "\n\n")

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

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return FurnitureOptions.makeArray(options: FurnitureOptions.init(rawValue: item.furnitureOptions)).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        return cell
    }
    
    
}
