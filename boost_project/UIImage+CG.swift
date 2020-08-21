//
//  UIImage+CG.swift
//  boost_project
//
//  Created by 현기엽 on 2020/08/14.
//  Copyright © 2020 남기범. All rights reserved.
//

import UIKit

extension UIImage {
    func drawRectangle(text: String, box: [Double]) -> UIImage {
        let imageSize = self.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        let context = UIGraphicsGetCurrentContext()

        let y1 = box[0]
        let x1 = box[1]
        let y2 = box[2]
        let x2 = box[3]
        
        // Draw Image
        self.draw(at: CGPoint.zero)
        let rectangle = CGRect(x: imageSize.width * CGFloat(x1), y: imageSize.height * CGFloat(y1), width: imageSize.width * CGFloat((x2 - x1)), height: imageSize.height * CGFloat(y2 - y1))

        context!.setStrokeColor(UIColor.orange.cgColor)
//        context!.addRect(rectangle)
        context!.stroke(rectangle, width: 2)
//        context!.drawPath(using: .stroke)
        
        
        // Draw Text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 16.0),
            .foregroundColor: UIColor.green
        ]
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let stringRect = CGRect(x: imageSize.width * CGFloat(x1), y: imageSize.height * CGFloat(y1) - 15, width: 100, height: 30)
        attributedString.draw(in: stringRect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
