//
//  Furniture.swift
//  boost_project
//
//  Created by 현기엽 on 2020/08/14.
//  Copyright © 2020 남기범. All rights reserved.
//

import Foundation

struct FurnitureOptions: OptionSet {
    let rawValue: Int
    
    static let 의자    = FurnitureOptions(rawValue: 1 << 0)
    static let 쇼파  = FurnitureOptions(rawValue: 1 << 1)
    static let 침대   = FurnitureOptions(rawValue: 1 << 2)
    static let 식사테이블   = FurnitureOptions(rawValue: 1 << 3)
    static let TV모니터   = FurnitureOptions(rawValue: 1 << 4)
    static let 전자레인지   = FurnitureOptions(rawValue: 1 << 5)
    static let 오븐   = FurnitureOptions(rawValue: 1 << 6)
    static let 냉장고   = FurnitureOptions(rawValue: 1 << 7)
    static let `default` = FurnitureOptions(rawValue: 1 << 8)
    
    static let all: FurnitureOptions = [.의자, .쇼파, .침대, .식사테이블, .TV모니터, .TV모니터, .전자레인지, .오븐, .냉장고]
    
    static func makeOptions(set: Set<String>) -> FurnitureOptions {
        FurnitureOptions(set.map { string -> FurnitureOptions in
            switch string {
            case "의자":
                return .의자
            case "쇼파":
                return .쇼파
            case "침대":
                return .침대
            case "식사테이블":
                return .식사테이블
            case "TV모니터":
                return .TV모니터
            case "전자레인지":
                return .전자레인지
            case "오븐":
                return .오븐
            case "냉장고":
                return .냉장고
            default:
                return .default
            }
        })
    }
}
