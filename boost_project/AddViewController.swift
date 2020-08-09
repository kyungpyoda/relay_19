//
//  AddViewController.swift
//  boost_project
//
//  Created by Byoung-Hwi Yoon on 2020/08/07.
//  Copyright © 2020 남기범. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

// 매물 추가화면 뷰 컨트롤러

class AddViewController: UIViewController {

    
    @IBOutlet var tf_address: UITextField!
    
    @IBOutlet var sgc_type: UISegmentedControl!
    
    @IBOutlet var tf_deposit: UITextField!
    
    @IBOutlet var tf_monthlyPrice: UITextField!
    
    @IBOutlet var tf_managementFee: UITextField!
    
    @IBOutlet var tf_area: UITextField!
    
    @IBOutlet var tf_detail: UITextField!
    
    var insertedId = 0
    var db : DBManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = DBManager.getInstance()
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
        
        //let db = DBManager.getInstance()
        insertedId = db?.insertRealEstateItem(item: item) ?? 0
        
        
        sendAPIRequest(with: item.address)
        
        if let detailText = tf_detail.text {
            sendAPIRequest(with: detailText)
        }
        
        /*
        
        let keywords = APIManager.getKeywords(from: item.address)
        
        for keyword in keywords{
            db?.insertKeyword(iid: insertedId, keyword: keyword)
        }
        
        let detailSentence = tf_detail.text ?? ""
        
        let hashTags = detailSentence.getArrayAfterRegex(regex: "#[a-zA-Z0-9가-힣]+").map { (slice) in slice.replacingOccurrences(of: "#", with: "")
        }
        
        for hashTag in hashTags {
            db?.insertKeyword(iid: insertedId, keyword: hashTag)
        }
        
        */
        
        
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
    
    func sendAPIRequest(with text: String){
        let gCloudAPIKey = "AIzaSyAUW0tQYuIOD-14WfCjqE1tki4yASLqzyc"

        print("Text: ", text)
        let jsonRequest =
            [
                "document":[
                    "type":"PLAIN_TEXT",
                    "content":"\(text)"
                ],
                "encodingType":"UTF8"
        ] as [String:Any]
            

        //let jsonObject = JSON(jsonRequest)

    

        let headers: HTTPHeaders = [
            "X-Ios-Bundle-Identifier": "\(Bundle.main.bundleIdentifier ?? "") ",
            "Content-Type": "application/json"
        ]
        
        let _ = AF.request("https://language.googleapis.com/v1beta2/documents:analyzeEntities?key=\(gCloudAPIKey)", method: .post , parameters: jsonRequest as [String: Any], encoding: JSONEncoding.default , headers: headers).responseJSON { (response) in
                //print(response)
            var keywords = [String]()
            if let JSON = response.value {
                if let dictionary = JSON as? [String: Any] {
                    if let entities = dictionary["entities"] as? NSArray{
                        for entity in entities {
                            if let item = entity as? [String:Any] {
                                print(item["name"]! as! String)
                                if let keyword = item["name"] {
                                    //keywords.append(keyword as? String)
                                    if let keywordString = keyword as? String {
                                        keywords.append(keywordString)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            for keyword in keywords{
                NSLog(keyword)
            }
            
            for keyword in keywords{
                self.db?.insertKeyword(iid: self.insertedId, keyword: keyword)
            }
            
            
            
            }
        }

}

extension String{
    func getArrayAfterRegex(regex: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
