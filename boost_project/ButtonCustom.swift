//
//  ButtonCustom.swift
//  boost_project
//
//  Created by 남기범 on 2020/08/06.
//  Copyright © 2020 남기범. All rights reserved.
//

import Foundation
import UIKit

class ButtonCustom:UIButton{
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 5
    }
}

class UITextFieldCustom:UITextField{
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 5
    }
}
