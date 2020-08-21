//
//  NaverMapAPI.swift
//  boost_project
//
//  Created by RoKang on 2020/08/21.
//  Copyright © 2020 남기범. All rights reserved.
//

import Foundation

class NaverMapAPI {
    typealias GEOData = (latitude: Double, longitude: Double)
    
    static func getCoordinate(with address: String, _ completion: ((GEOData) -> Void)? = nil) {
        guard URL(string: "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode") != nil else
        { return }
        
        guard var urlComponents = URLComponents(string: "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode") else { return }
        urlComponents.queryItems = [URLQueryItem(name: "query", value: address)]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.addValue("dei9irsrd9", forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue("Xt1Xn3zo3DKxphAgxHXBWAqBt1CdZtKCD2MGQDms", forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let data = data else { print("Empty data"); return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let array = json!["addresses"] as? [Any],
                    let dic = array[0] as? [String: Any],
                    let longitude = dic["x"] as? String,
                    let latitude = dic["y"] as? String else { return }
                
//                print(latitude, longitude)
                completion?(GEOData(Double(latitude) ?? 0.0, Double(longitude) ?? 0.0))
            } catch {
                print(error)
            }
            
            if let str = String(data: data, encoding: .utf8) {
                print(str)
            }
        }.resume()
    }
}
