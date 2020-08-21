//
//  test.swift
//  final-ML
//
//  Created by 최동규 on 2020/08/21.
//  Copyright © 2020 최동규. All rights reserved.
//

import Foundation

// size : 건물 면적 = 단위 m^2, contractYearMonth : 계약연월 = ex) YYYYMM, floor : 실거주 층수 = ex) 3, yearOfBuilding : 준공년도 = ex) 1997, LocationCode : 지역 위치(서울에 한함) 위 딕셔너리 참조

class RealEstateModel {
    static func predictionSellPrice(size: Double, contractYearMonth: Double, floor: Double, yearOfBuilding: Double, location : Double) throws -> Double
    {
        let test = BoostDongsan_2()
        return try test.prediction(size: size, contractYearMonth: contractYearMonth, floor: floor, yearOfBuilding: yearOfBuilding, location: location).sellPrice
    }
    
    static let SeoulRegionCode: [String: Double] = [
        "강남구":1,
        "강동구":2,
        "강북구":3,
        "강서구":4,
        "관악구":5,
        "광진구":6,
        "구로구":7,
        "금천구":8,
        "노원구":9,
        "도봉구":10,
        "동대문구":11,
        "동작구":12,
        "마포구":13,
        "서대문구":14,
        "서초구":15,
        "성동구":16,
        "성북구":17,
        "송파구":18,
        "양천구":19,
        "영등포구":20,
        "용산구":21,
        "은평구":22,
        "종로구":23,
        "중구":24,
        "중랑구":25
    ]
}
