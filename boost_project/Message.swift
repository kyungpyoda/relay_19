//
//  Message.swift
//  boost_project
//
//  Created by 남기범 on 2020/08/02.
//  Copyright © 2020 남기범. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct Sender: SenderType{
    var senderId: String
    var displayName: String
}

struct Message: MessageType{
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    var item: RealEstateItem?
}

