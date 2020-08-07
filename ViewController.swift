//
//  ViewController.swift
//  boost_project
//
//  Created by 남기범 on 2020/08/02.
//  Copyright © 2020 남기범. All rights reserved.
//

import UIKit
import MessageKit

class ViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    let currentUser = Sender(senderId: "self", displayName: "iOS Academy")
    let otherUser = Sender(senderId: "other", displayName: "John Smith")
    var messages = [MessageType]()
    let db = DBManager.getInstance()
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.sendButton.addTarget(self, action: #selector(self.sendAction(sender:)), for: .touchUpInside)
        
        messageInputBar.inputTextView.becomeFirstResponder()
        
    }
    
    @IBAction func sendAction(sender: UIButton){
        //input data 추출 및 메시지 추가
        let inputData = messageInputBar.inputTextView.text
        messages.append(Message(sender: currentUser,
        messageId: "5",
        sentDate: Date(),
        kind: .text(inputData ?? "")))
        
        /*
         통신
         input : inputData
         output : json 파싱 값
        */
        
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
            kind: .text("\(item.address) ")))
        }
        
        if realEstateItems.count == 0 {
            messages.append(Message(sender: otherUser,
            messageId: "6",
            sentDate: Date(),
            kind: .text("해당하는 매물을 찾을 수 없습니다.")))
        }
        
        //응답 메시지
        //messages.append(Message(sender: otherUser,
        //messageId: "6",
        //sentDate: Date(),
        //kind: .text("hi!")))
        messageInputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        
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

