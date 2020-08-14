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
import TextFieldEffects

// 매물 추가화면 뷰 컨트롤러

class AddViewController: UIViewController {

    var insertedId = 0
    var db : DBManager?
    
    @IBOutlet var tf_address: JiroTextField!
    @IBOutlet var sgc_type: UISegmentedControl!
    @IBOutlet var tf_deposit: JiroTextField!
    @IBOutlet weak var tf_monthlyPrice: JiroTextField!
    @IBOutlet var tf_managementFee: JiroTextField!
    @IBOutlet var tf_area: JiroTextField!
    @IBOutlet var tf_detail: UITextField!
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.gray
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
        
        // DB Insert Test
//        let imageName = "logo"
//
//        let uniqueName = String(Date().timeIntervalSinceNow)
//        UIImage(named:imageName)!.save(uniqueName)
//
//        item.imageName = uniqueName
//        let options = FurnitureOptions.makeOptions(set: Set<String>(arrayLiteral: "냉장고"))
//        item.furnitureOptions = options.rawValue

        insertedId = db?.insertRealEstateItem(item: item) ?? 0
        sendAPIRequest(with: item.address)

        // DB Find Test
//        let ite2m = (db?.findByIID(iid: insertedId)[0].imageName)!
//        let uiimage = UIImage.load(ite2m)
//        let imageView  = UIImageView(frame:CGRect(x: 10, y: 50, width: 100, height: 300));
//        imageView.image = uiimage
//        view.addSubview(imageView)
        
        if let detailText = tf_detail.text {
            sendAPIRequest(with: detailText)
        }
        
        /* API연결 전 데모 사용 부분
        
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
    
    
    @IBAction func textFieldKeyboardWillShow(_ sender: UITextFieldCustom) {
        self.view.frame.origin.y = -150
    }
    
    @IBAction func textFieldKeyboardWillHidden(_ sender: Any) {
        self.view.frame.origin.y = 0
    }
    
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
            
        let headers: HTTPHeaders = [
            "X-Ios-Bundle-Identifier": "\(Bundle.main.bundleIdentifier ?? "") ",
            "Content-Type": "application/json"
        ]
        
        let _ = AF.request("https://language.googleapis.com/v1beta2/documents:analyzeEntities?key=\(gCloudAPIKey)", method: .post , parameters: jsonRequest as [String: Any], encoding: JSONEncoding.default , headers: headers).responseJSON { (response) in
            
            var keywords = [String]()
            
            guard let JSON = response.value else { return }
            
            guard let jsonData = JSON as? [String: Any] else { return }
            
            guard let entities = jsonData["entities"] as? NSArray else { return }
            
            for entity in entities {
                if let item = entity as? [String:Any] {
                    if let keyword = item["name"] {
                        if let keywordString = keyword as? String {
                            keywords.append(keywordString)
                        }
                    }
                }
            }
            
            // API response 사용 부분, 별도 콜백메소드로 작성하면 좋을듯
            
            for keyword in keywords{
                NSLog("Keyword: \(keyword)")
                self.db?.insertKeyword(iid: self.insertedId, keyword: keyword)
            }
            }
        }

}

/* API연결 전 데모 사용을 위한 해시태그 추출
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
*/
