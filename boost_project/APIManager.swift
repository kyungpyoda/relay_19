//
//  APIManager.swift
//  boost_project
//
//  Created by Byoung-Hwi Yoon on 2020/08/07.
//  Copyright © 2020 남기범. All rights reserved.
//

import Foundation

// API를 이용한 키워드 추출 역할 데모
// API사용 성공했으므로 불필요

class APIManager {
    
    static func getKeywords(from input : String) -> [String] {
        
        var keywords = [String]()
        
        keywords = input.components(separatedBy: " ")
        
        return keywords
        
        
    }
    
}
