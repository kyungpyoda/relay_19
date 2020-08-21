//
//  AddImageViewController.swift
//  boost_project
//
//  Created by woong on 2020/08/14.
//  Copyright © 2020 남기범. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import TextFieldEffects

class AddImageViewController: UIViewController {

    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBackgroundView: UIView!
    
    var furnitureList = [Furniture]() {
        didSet {
            selectList = furnitureList
            DispatchQueue.main.async {
                self.tagTableView.reloadData()
            }
        }
    }
    var selectList = [Furniture]()
    let picker = UIImagePickerController()
    var realEstateItem: RealEstateItem?
    let db = DBManager.getInstance()
    var insertedId = 0

    @IBAction func onClickSave(_ sender: UIBarButtonItem) {
        
        
        let options = FurnitureOptions.makeOptions(set: selectList.map {$0.name})
        self.realEstateItem?.furnitureOptions = options.rawValue
        if let item = realEstateItem {
            insertedId = db.insertRealEstateItem(item: item)
            sendAPIRequest(with: item.address)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGesture() 
        configureTableView()
        configureViews()
        
        picker.delegate = self
        selectList = furnitureList
    }
    
    func configureViews() {
        imageBackgroundView.layer.shadowColor = UIColor.black.cgColor
        imageBackgroundView.layer.shadowOpacity = 0.5
        imageBackgroundView.layer.shadowOffset = .init(width: 3, height: 3)
        imageBackgroundView.layer.cornerRadius = 15
        imageView.layer.cornerRadius = 15
    }
    
    func configureTableView() {
        tagTableView.separatorStyle = .none
        tagTableView.allowsSelection = false
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapImageView() {
        openLibrary()
    }
    
    func openLibrary(){
      picker.sourceType = .photoLibrary
      present(picker, animated: false, completion: nil)
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
            self.db.insertKeyword(iid: self.insertedId, keyword: keyword)
        }
        }
    }

}

extension AddImageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return furnitureList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FurnitureTableViewCell else { return UITableViewCell() }
        
        let furniture = furnitureList[indexPath.row]
        let selected = selectList.contains(furniture)
        cell.configure(furniture: furniture, isSelected: selected) { [weak self] (furniture, selected) in
            if selected {
                self?.selectList.append(furniture)
            } else {
                self?.selectList.removeAll(where: { $0 == furniture })
            }
            print(self?.selectList.count)
        }
        
        return cell
    }
    
    
    
}

extension AddImageViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(named: "backgroundColor")
        let label = UILabel()
        view.addSubview(label)
        label.text = "인식된 물체"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "인식된 물체"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension AddImageViewController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
//        let uniqueName = String(Date().timeIntervalSinceNow)
//        UIImage(named:imageName)!.save(uniqueName)
//
//        item.imageName = uniqueName
//        let options = FurnitureOptions.makeOptions(set: Set<String>(arrayLiteral: "냉장고"))
//        item.furnitureOptions = options.rawValue
//
//        insertedId = db?.insertRealEstateItem(item: item) ?? 0
        
        if var image = info[.originalImage] as? UIImage {
            let imagePath = "\(Date().timeIntervalSince1970)"
            realEstateItem?.imageName = imagePath
            
            let urlString = "https://naveropenapi.apigw.ntruss.com/vision-obj/v1/detect"
            let data = image.jpegData(compressionQuality: 1)
            APIManager.shared.requestDetectionWith(endUrl: urlString, imageData: data) { furnitureList, detectedBoxes in
                self.furnitureList = furnitureList.map { Furniture(name: $0) }
                for (name, box) in detectedBoxes {
                    image = image.drawRectangle(text: name, box: box)
                }
                DispatchQueue.main.async {
                    image.save(imagePath)
                    self.imageView.image = image
                }
            }
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

