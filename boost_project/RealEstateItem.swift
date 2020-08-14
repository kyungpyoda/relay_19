//
//  RealEstateItem.swift
//  boost_project
//
//  Created by Byoung-Hwi Yoon on 2020/08/07.
//  Copyright © 2020 남기범. All rights reserved.
//

import Foundation

 // 매물 아이템 테이블 Column , 옵션들은 매물아이템 ID - 옵션 테이블을 생성해서 별도로 저장
class RealEstateItem {
   
    var id : Int = 0
    var address : String = ""
    var type : String = ""
    var structType : String = ""
    var depositPrice : Int = 0
    var monthlyPrice : Int = 0
    var managementFee : Int = 0
    var area : Int = 0
}
