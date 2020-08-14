//
// APIManager.swift
// boost_project
//
// Created by Byoung-Hwi Yoon on 2020/08/07.
// Copyright © 2020 남기범. All rights reserved.
//

import Foundation
import Alamofire
struct DetectedObject: Codable {
  var predictions: [Objects?]
}
struct Objects: Codable {
  var detection_names: [String]
  var detection_scores: [Double]
}
class APIManager {
  let koreanMap = ["chair":"의자", "couch":"소파", "bed":"침대", "dining table":"식사테이블", "tv":"TV모니터", "microwave":"전자레인지", "oven":"오븐", "refrigerator":"냉장고"]
   
  public static let shared = APIManager()
  private init() {}
   
   
  func requestDetectionWith(endUrl: String, imageData: Data?, onCompletion: @escaping (([String]) -> Void)){
    guard let imageData = imageData else { return }
    let headers: HTTPHeaders = [
      "X-NCP-APIGW-API-KEY-ID": "6d2ujbq6pp",
      "X-NCP-APIGW-API-KEY" : "8b5KNBSFVKFMa3b8udEv792oOtFpOame8dKur2UF",
      "Content-Type": "multipart/form-data"
    ]
     
    // let image: UIImage = UIImage(named: "test.png")!
//
//    guard let imageData = image.jpegData(compressionQuality: 1.0) else {
//      return
//    }
     
    AF.upload(multipartFormData: { MultipartFormData in
      MultipartFormData.append(imageData,
                   withName: "image",
                   fileName: "\(Date().timeIntervalSince1970)",
                   mimeType: "image/jpeg")
       
    },to: endUrl, method: .post, headers: headers)
      .responseJSON { response in
        switch response.result {
        case .success(let value):
          do {
            let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
            let detectedObject = try JSONDecoder().decode(DetectedObject.self, from: data)
             
            let objects = detectedObject.predictions.map {$0!.detection_names}.first!
            let scores = detectedObject.predictions.map {$0!.detection_scores}.first!
            var processedData = [String]()
            for (name, score) in zip(objects, scores) {
                print(name, score)
//              if score > 0.95 {
//                processedData.append(name)
//              }
                processedData.append(name)
            }
            let objectSet = Set(processedData).map {self.koreanMap[$0] ?? ""}.filter {$0 != ""}
            onCompletion(objectSet)
          } catch {
            print(error.localizedDescription)
          }
        case .failure(let error):
          print(error.errorDescription!)
        }
    }
  }
}

