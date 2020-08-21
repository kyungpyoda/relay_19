//
//  DetailViewController.swift
//  boost_project
//
//  Created by Byoung-Hwi Yoon on 2020/08/08.
//  Copyright © 2020 남기범. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    var item : RealEstateItem = RealEstateItem() {
        willSet {
            NaverMapAPI.getCoordinate(with: newValue.address) { geoData in
                self.currentCoordination = geoData
                self.setupMapView()
            }
        }
    }
    
    @IBOutlet var lbl_Address: UILabel!
    
    @IBOutlet var lbl_Type: UILabel!
    
    @IBOutlet var lbl_Price: UILabel!
    
    @IBOutlet var lbl_Area: UILabel!
    
    @IBOutlet var lbl_ManagementFee: UILabel!
    
    @IBOutlet var lbl_Struct: UILabel!
    
    @IBOutlet weak var realImageView: UIImageView!
    @IBOutlet var lbl_Options: UILabel!
    
    @IBOutlet weak var infoTypeChanger: UISegmentedControl!
    
    @IBOutlet weak var normalView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var predictedPriceLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    private var currentCoordination: NaverMapAPI.GEOData = (0, 0)
    
    private var predictedPriceText: String {
        do {
            var price = try RealEstateModel.predictionSellPrice(size: 103, contractYearMonth: 202008, floor: 10, yearOfBuilding: 1984, location: RealEstateModel.SeoulRegionCode["강남구"] ?? 1)
            price = (price / 100).rounded()
            let priceText = String(price / 100).split(separator: ".").map({ String($0) })
            return "\(priceText[0])억 \(priceText[1])00만원"
        } catch {
            print(error)
            return "(가격 정보 없음)"
        }
    }
    
    override func viewDidLoad() {
        NSLog("상세뷰 켜짐")
        super.viewDidLoad()
        
        // Label 데이터 셋업
        setupLabels()
        
        // 옵션 문자열 생성
        let furnitureList = FurnitureOptions.makeArray(options: FurnitureOptions.init(rawValue: item.furnitureOptions))
        lbl_Options.text = furnitureList.map{ "#\($0)" }.joined(separator: ", ")
    }
    
    private func setupMapView() {
        let latitude = self.currentCoordination.latitude
        let longitude = self.currentCoordination.longitude
        map.moveToLocation(CLLocation(latitude: latitude, longitude: longitude))
        map.pin(latitudeValue: latitude, longitudeValue: longitude, delta: 0.1, title: "매물 위치", subtitle: "강남역")
    }
    
    private func setupLabels() {
        lbl_Address.text = "주소: \(item.address)"
        lbl_Type.text = item.type
        lbl_Area.text = "\(item.area) ㎡"
        lbl_ManagementFee.text = "\(item.managementFee) 만원"
        lbl_Struct.text = item.structType
        realImageView.image = UIImage.load(item.imageName)
        
        if item.monthlyPrice == 0 {
            lbl_Price.text = "\(item.depositPrice)"
        } else {
            lbl_Price.text = "\(item.depositPrice) / \(item.monthlyPrice)"
        }
        
        if item.type == "전세" {
            lbl_Struct.text = "투룸"
        } else {
            lbl_Struct.text = "분리형 원룸"
        }
        
        // 매물 거래예측가 설정
        self.predictedPriceLabel.text = self.predictedPriceText
    }
    
    @IBAction func changeContentMode(_ sender: UISegmentedControl) {
        if 0 == sender.selectedSegmentIndex {
            // 기본
            self.normalView.isHidden = false
            self.detailView.isHidden = true
        } else if 1 == sender.selectedSegmentIndex {
            // 심화
            self.normalView.isHidden = true
            self.detailView.isHidden = false
        }
    }

}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return FurnitureOptions.makeArray(options: FurnitureOptions.init(rawValue: item.furnitureOptions)).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        return cell
    }
    
    
}

extension MKMapView {
    func moveToLocation(_ location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: regionRadius)
        self.setRegion(coordinateRegion, animated: true)
    }
    
    func pin(latitudeValue: CLLocationDegrees,
                     longitudeValue: CLLocationDegrees,
                     delta span: Double,
                     title strTitle: String,
                     subtitle strSubTitle:String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longtudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        self.addAnnotation(annotation)
    }
    
    func goLocation(latitudeValue: CLLocationDegrees,
                            longtudeValue: CLLocationDegrees,
                            delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        self.setRegion(pRegion, animated: true)
        return pLocation
    }
}
