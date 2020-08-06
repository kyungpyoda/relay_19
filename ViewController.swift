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
        
        //응답 메시지
        messages.append(Message(sender: otherUser,
        messageId: "6",
        sentDate: Date(),
        kind: .text("hi!")))
        messageInputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
    }
}

