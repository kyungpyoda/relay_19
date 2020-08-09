//
//  ViewController.swift
//  boost_project
//
//  Created by 남기범 on 2020/08/02.
//  Copyright © 2020 남기범. All rights reserved.
//

import UIKit
import MessageKit
import SwiftyJSON
import Alamofire

class ViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    let currentUser = Sender(senderId: "self", displayName: "iOS Academy")
    let otherUser = Sender(senderId: "other", displayName: "John Smith")
    var messages = [MessageType]()
    let db = DBManager.getInstance()
    
    var nextDetailItem : RealEstateItem = RealEstateItem()
    
    let messageBoxColor = UIColor(displayP3Red: 236/255, green: 230/255, blue: 204/255, alpha: 1)
    let backgroundColor = UIColor(displayP3Red: 244/255, green: 241/255, blue: 234/255, alpha: 1)
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? UIColor(displayP3Red: 227/255, green: 227/255, blue: 224/255, alpha: 1) : messageBoxColor
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor.black
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
      avatarView.isHidden = true
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if message.messageId == "4" {
            return 30
        }
        
        return 5
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.sendButton.addTarget(self, action: #selector(self.sendAction(sender:)), for: .touchUpInside)
        
        messageInputBar.inputTextView.becomeFirstResponder()
        
        messages.append(Message(sender: otherUser,
        messageId: "4",
        sentDate: Date(),
        kind: .text("어떤 집을 찾아드릴까요?")))
        
        messagesCollectionView.reloadData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCollectionView()
        self.navigationController?.navigationBar.barTintColor = backgroundColor
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        messageInputBar.backgroundView.backgroundColor = backgroundColor
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        //layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 50))
        layout?.setMessageOutgoingMessagePadding(UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 4))
    }
    
    private func setupCollectionView() {
            guard let flowLayout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else {
                NSLog("Can't get flowLayout")
                return
            }
            if #available(iOS 13.0, *) {
                flowLayout.collectionView?.backgroundColor = backgroundColor
            }
    }
    
    @IBAction func sendAction(sender: UIButton){
        //input data 추출 및 메시지 추가
        let inputData = messageInputBar.inputTextView.text
        messages.append(Message(sender: currentUser,
        messageId: "5",
        sentDate: Date(),
        kind: .text(inputData ?? "")))
        
       
        sendAPIRequest(with: inputData ?? "")
        /*
         통신
         input : inputData
         output : json 파싱 값
        */
        /*
        let keywords = APIManager.getKeywords(from: inputData ?? "")
        //var iidSet = Set<Int>()
        var iidDic = [Int:Int]()
        for keyword in keywords {
            let items = db.findByKeyword(keyword: keyword)
            
            for item in items {
                iidDic.updateValue((iidDic[item.iid] ?? 0) + 1, forKey: item.iid)
                //iidSet.update(with: item.iid)
            }
        }
        
        let bestMatchID = getBestMatchs(iidDic)
        
       
        var realEstateItems = [RealEstateItem]()
        
        for iid in bestMatchID {
            let items = db.findByIID(iid: iid)
            realEstateItems.append(contentsOf: items)
        }
        
        for item in realEstateItems {
            messages.append(Message(sender: otherUser,
            messageId: "7",
            sentDate: Date(),
            kind: .text("\(item.address) "),
            item: item))
        }
        
        if realEstateItems.count == 0 {
            messages.append(Message(sender: otherUser,
            messageId: "6",
            sentDate: Date(),
            kind: .text("해당하는 매물을 찾을 수 없습니다.")))
        }
        */
        
        //응답 메시지
        //messages.append(Message(sender: otherUser,
        //messageId: "6",
        //sentDate: Date(),
        //kind: .text("hi!")))
        messageInputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
        
    }
    
    func getBestMatchs(_ items : [Int:Int]) -> [Int] {
        
        if items.count == 0 {
            return [Int]()
        }
        
        let sortedItems = items.sorted { $0.1 > $1.1 }
        
        let bestMatchCount = sortedItems[0].value
        
        var bestMatchedIds = [Int]()
        
        for item in sortedItems {
            if item.value == bestMatchCount{
                bestMatchedIds.append(item.key)
                continue
            }
            break
        }
        
        return bestMatchedIds
        
    }
    
}

extension ViewController : MessageCellDelegate{
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        let indexPath = messagesCollectionView.indexPath(for: cell)
        let message = messages[(indexPath?.section)!]
        NSLog("TAP")
        NSLog((message as? Message)?.item?.address ?? "No item")
        
        if let selectedItem = (message as? Message)?.item {
            /*
            guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") else{
                return
            }
            self.navigationController?.pushViewController(uvc, animated: true)
 */
            self.nextDetailItem = selectedItem
            self.performSegue(withIdentifier: "ShowItemDetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItemDetail" {
            (segue.destination as? DetailViewController)?.item = nextDetailItem
        }
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
            
            
            var iidDic = [Int:Int]()
             for keyword in keywords {
                let items = self.db.findByKeyword(keyword: keyword)
                 
                 for item in items {
                     iidDic.updateValue((iidDic[item.iid] ?? 0) + 1, forKey: item.iid)
                     //iidSet.update(with: item.iid)
                 }
             }
             
            let bestMatchID = self.getBestMatchs(iidDic)
             
            
             var realEstateItems = [RealEstateItem]()
             
             for iid in bestMatchID {
                let items = self.db.findByIID(iid: iid)
                 realEstateItems.append(contentsOf: items)
             }
             
             for item in realEstateItems {
                self.messages.append(Message(sender: self.otherUser,
                 messageId: "7",
                 sentDate: Date(),
                 kind: .text("\(item.address) "),
                 item: item))
             }
            
            if realEstateItems.count == 0 {
                self.messages.append(Message(sender: self.otherUser,
                messageId: "6",
                sentDate: Date(),
                kind: .text("해당하는 매물을 찾을 수 없습니다.")))
            }
            
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom(animated: true)
            
            
            }
        }
    
}
